import os
import re
from flask import Flask, render_template, request, redirect, url_for, session
import PyPDF2
import docx
from ebooklib import epub

app = Flask(__name__)
app.secret_key = 'YOUR_SECRET_KEY'  # 세션 사용을 위해 임의 문자열 설정

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


def extract_text(filepath):
    """
    업로드된 파일의 확장자를 확인하고,
    PDF, EPUB, DOCX에 맞춰 텍스트를 추출한다.
    """
    ext = os.path.splitext(filepath)[1].lower()
    if ext == '.pdf':
        return extract_text_from_pdf(filepath)
    elif ext == '.epub':
        return extract_text_from_epub(filepath)
    elif ext in ['.doc', '.docx']:
        return extract_text_from_docx(filepath)
    else:
        return ""

def extract_text_from_pdf(filepath):
    text = ""
    with open(filepath, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                text += page_text + "\n"
    return text

def extract_text_from_epub(filepath):
    text = ""
    book = epub.read_epub(filepath)
    for item in book.get_items():
        if item.get_type() == epub.EpubHtml:
            content = item.get_content().decode('utf-8', errors='ignore')
            text += content + "\n"
    return text

def extract_text_from_docx(filepath):
    doc = docx.Document(filepath)
    # 각 단락을 줄바꿈으로 연결
    text = "\n".join([para.text for para in doc.paragraphs])
    return text


def split_text_custom(text, chunk_size=220, max_pages=10):
    """
    1) 먼저 '처음 (max_pages - 1)개 페이지'는 문장 여부와 상관없이 정확히 220자씩 자른다.
    2) 마지막에 남은 텍스트는 문장 단위(최대 220자씩)로 분할한다.
    3) 최종적으로 페이지가 10개를 넘으면 잘라낸다.
    """

    # -------------------------
    # 1) 처음 (max_pages - 1)개 페이지는 220자씩 '무조건' 자르기
    # -------------------------
    pages = []
    pos = 0
    text_len = len(text)
    # (max_pages - 1)번 반복 (예: 최대 9번)
    for _ in range(max_pages - 1):
        # 남은 텍스트가 220자보다 작으면 중단
        if pos + chunk_size >= text_len:
            break
        # 220자 추출
        chunk = text[pos:pos + chunk_size]
        pages.append(chunk)
        pos += chunk_size

    # -------------------------
    # 2) 마지막에 남은 부분을 문장 단위로 220자씩 분할
    # -------------------------
    leftover = text[pos:]  # 아직 처리 안 된 부분
    if leftover:
        sentence_chunks = split_text_by_sentence(leftover, chunk_size)
        pages.extend(sentence_chunks)

    # -------------------------
    # 3) 최종 페이지를 max_pages개로 제한
    # -------------------------
    pages = pages[:max_pages]

    return pages


def split_text_by_sentence(text, chunk_size=220):
    """
    문장을 '.', '?', '!' 뒤에서 나누고,
    각 문장을 최대 220자 내외로 모아서 여러 페이지(덩어리)로 만든다.
    """
    # 1) 구두점(., ?, !)을 기준으로 split하되, 구두점을 버리지 않기 위해 re.split에서 캡처 그룹을 사용
    tokens = re.split('([.?!])', text)

    # 2) 문장 + 구두점을 합쳐서 하나의 문장으로 정리
    sentences = []
    for i in range(0, len(tokens), 2):
        if i + 1 < len(tokens):
            sentence = tokens[i].strip() + tokens[i+1]
        else:
            sentence = tokens[i].strip()
        sentence = sentence.strip()
        if sentence:
            sentences.append(sentence)

    # 3) 220자 내외로 문장을 모아서 분할
    chunks = []
    current_chunk = ""
    for sentence in sentences:
        # 다음 문장을 추가했을 때 220자를 초과하면 새 덩어리
        if len(current_chunk) + len(sentence) + 1 <= chunk_size:
            if current_chunk:
                current_chunk += " "
            current_chunk += sentence
        else:
            if current_chunk:
                chunks.append(current_chunk)
            current_chunk = sentence

    # 마지막 덩어리 추가
    if current_chunk:
        chunks.append(current_chunk)

    return chunks


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/upload', methods=['POST'])
def upload():
    uploaded_file = request.files.get('file')
    if uploaded_file:
        # 1) 파일 저장
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], uploaded_file.filename)
        uploaded_file.save(filepath)

        # 2) 텍스트 추출
        extracted_text = extract_text(filepath)

        # 3) 커스텀 분할 함수 호출
        pages = split_text_custom(extracted_text, chunk_size=220, max_pages=10)

        # 4) 세션에 저장
        session['pages'] = pages

        # 5) 첫 페이지로 이동
        return redirect(url_for('show_page', page_number=1))

    return "파일 업로드 실패"


@app.route('/page/<int:page_number>')
def show_page(page_number):
    pages = session.get('pages', [])
    total_pages = len(pages)

    if total_pages == 0:
        return "아직 업로드된 텍스트가 없습니다."

    # 페이지 번호가 범위를 벗어나면 404
    if page_number < 1 or page_number > total_pages:
        return "잘못된 페이지 번호입니다.", 404

    # 현재 페이지 내용
    page_content = pages[page_number - 1]

    return render_template(
        'pagination.html',
        page_content=page_content,
        page_number=page_number,
        total_pages=total_pages
    )


if __name__ == '__main__':
    app.run(debug=True)