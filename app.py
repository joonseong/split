import os
import re
import uuid
from flask import Flask, render_template, request, redirect, url_for
from werkzeug.utils import secure_filename
import PyPDF2

app = Flask(__name__)
app.secret_key = 'YOUR_SECRET_KEY'  # 적절한 비밀키로 변경

# 업로드 폴더 설정
app.config['UPLOAD_FOLDER'] = 'uploads'

# uploads 폴더가 없으면 자동 생성
if not os.path.exists(app.config['UPLOAD_FOLDER']):
    os.makedirs(app.config['UPLOAD_FOLDER'])

# 전역 딕셔너리: { series_id: { 'title': str, 'pages': [str, ...] } }
SERIES_DB = {}

def extract_text_from_pdf(filepath):
    """
    PDF 파일에서 텍스트를 추출 (단순 예시).
    필요에 따라 오류 처리, 이미지 추출, EPUB/Word 등 확장 가능.
    """
    text = ""
    with open(filepath, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                text += page_text + "\n"
    return text

def extract_text_and_images(filepath):
    """
    PDF에서 텍스트(및 이미지)를 순서대로 추출한다고 가정.
    여기서는 텍스트만 추출해 ("text", 전체텍스트) 형태로 반환.
    """
    items = []
    text_content = extract_text_from_pdf(filepath)
    items.append(("text", text_content))
    # 이미지 추출 로직이 필요하다면, ("image", {...}) 형태로 추가
    return items

def split_text_by_rules(text, max_chars=220, max_lines=12):
    """
    문자열을 줄바꿈(\n) 기준으로 나눈 뒤,
    한 덩어리의 글자 수가 max_chars를 초과하거나
    줄 수가 max_lines를 초과하면 새 덩어리로 분할.
    """
    lines = text.split('\n')
    chunks = []
    current_chunk = []
    current_char_count = 0
    current_line_count = 0

    for line in lines:
        line_length = len(line)
        # 다음 줄을 추가했을 때 max_lines 또는 max_chars를 초과하면 분할
        if (current_line_count + 1 > max_lines) or (current_char_count + line_length > max_chars):
            chunks.append("\n".join(current_chunk))
            current_chunk = []
            current_char_count = 0
            current_line_count = 0

        current_chunk.append(line)
        current_char_count += line_length
        current_line_count += 1

    # 마지막 덩어리
    if current_chunk:
        chunks.append("\n".join(current_chunk))

    return chunks

def ordinal(num):
    """
    1~10까지 한글 서수(첫번째, 두번째...) 반환,
    그 외는 '{num}번째'로 반환.
    """
    ordinals = {
        1: "첫번째",
        2: "두번째",
        3: "세번째",
        4: "네번째",
        5: "다섯번째",
        6: "여섯번째",
        7: "일곱번째",
        8: "여덟번째",
        9: "아홉번째",
        10: "열번째"
    }
    return ordinals.get(num, f"{num}번째")

def split_items_into_series(items, max_chars=220, max_lines=12, pages_per_series=10):
    """
    items = [("text", "..."), ("image", {...}), ...]
    - "text" 항목을 최대 220자 or 최대 12줄씩 분할 -> pages
    - 한 시리즈당 pages_per_series (기본 10)페이지씩 그룹핑
    - 시리즈 제목: "첫번째 시리즈", "두번째 시리즈" 등
    반환: [{ 'id': ..., 'title': ..., 'pages': [...] }, ...]
    """
    series_list = []
    for item_type, content in items:
        if item_type == "text":
            text_chunks = split_text_by_rules(content, max_chars, max_lines)
            total_pages = len(text_chunks)
            series_count = 0

            # 10페이지씩 끊어서 여러 시리즈로 생성
            for i in range(0, total_pages, pages_per_series):
                series_count += 1
                part_pages = text_chunks[i:i+pages_per_series]
                title = f"{ordinal(series_count)} 시리즈"
                series_list.append({
                    'id': str(uuid.uuid4()),
                    'title': title,
                    'pages': part_pages
                })

        # "image" 항목을 페이지에 섞으려면 추가 로직 필요

    return series_list


@app.route('/')
def index():
    """
    메인 페이지: 파일 업로드 폼 (index.html 렌더링)
    """
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
    """
    파일 업로드 처리:
    - PDF 저장
    - 텍스트 추출 및 분할
    - 시리즈 DB에 저장
    - 시리즈 목록 페이지로 이동
    """
    uploaded_file = request.files.get('file')
    if not uploaded_file:
        return "파일이 업로드되지 않았습니다.", 400

    filename = secure_filename(uploaded_file.filename)
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    uploaded_file.save(filepath)

    # PDF 텍스트 추출 (이미지 추출은 생략)
    items = extract_text_and_images(filepath)

    # 텍스트를 분할 -> 여러 시리즈로 생성
    series_list = split_items_into_series(items, max_chars=220, max_lines=12, pages_per_series=10)

    # SERIES_DB에 시리즈 저장
    for series in series_list:
        SERIES_DB[series['id']] = series

    return redirect(url_for('series_list'))

@app.route('/series')
def series_list():
    """
    시리즈 목록 페이지 (series_list.html 렌더링)
    """
    return render_template('series_list.html', series_db=SERIES_DB)

@app.route('/series/<series_id>/page/<int:page_number>')
def show_page(series_id, page_number):
    """
    페이지네이션:
    - 시리즈 ID로부터 pages 가져옴
    - page_number 범위 확인
    - 마지막 페이지면 이전/다음 시리즈 계산
    """
    series = SERIES_DB.get(series_id)
    if not series:
        return "존재하지 않는 시리즈입니다.", 404

    pages = series['pages']
    total_pages = len(pages)
    if page_number < 1 or page_number > total_pages:
        return "잘못된 페이지 번호입니다.", 404

    page_content = pages[page_number - 1]

    # 이전/다음 시리즈 버튼을 위해 None으로 초기화
    prev_series_id = None
    next_series_id = None

    # 마지막 페이지인 경우 이전/다음 시리즈 계산
    if page_number == total_pages:
        list_series = list(SERIES_DB.items())  # [(sid, {...}), (sid2, {...}), ...]
        current_index = None

        # 현재 시리즈가 몇 번째인지 찾기
        for i, (sid, sdata) in enumerate(list_series):
            if sid == series_id:
                current_index = i
                break

        if current_index is not None:
            # 이전 시리즈
            if current_index > 0:
                prev_series_id = list_series[current_index - 1][0]
            # 다음 시리즈
            if current_index < len(list_series) - 1:
                next_series_id = list_series[current_index + 1][0]

    return render_template(
        'pagination.html',
        page_items=[("text", page_content)],
        page_number=page_number,
        total_pages=total_pages,
        series_id=series_id,
        series_title=series['title'],
        prev_series_id=prev_series_id,
        next_series_id=next_series_id
    )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)