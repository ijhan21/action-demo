# Python 3.12 slim 이미지를 베이스로 사용
# slim 버전은 불필요한 패키지를 제거하여 이미지 크기를 줄인 버전입니다
FROM python:3.12-slim

# 작업 디렉토리 설정
# 컨테이너 내부에서 앱 파일들이 위치할 디렉토리입니다
WORKDIR /app

# requirements.txt를 먼저 복사
# 이렇게 하면 소스 코드가 변경되어도 의존성이 변경되지 않았다면
# Docker는 캐시된 레이어를 재사용하여 빌드 속도를 높입니다
COPY requirements.txt .

# Python 패키지 설치
# --no-cache-dir: pip 캐시를 저장하지 않아 이미지 크기 감소
# --upgrade: pip를 최신 버전으로 업그레이드
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 애플리케이션 코드 복사
# 소스 코드는 의존성 설치 후에 복사합니다
COPY . .

# 컨테이너가 8000번 포트를 사용함을 명시
# 이는 문서화 목적이며, 실제로 포트를 개방하지는 않습니다
EXPOSE 8000

# 컨테이너 시작 시 실행할 명령
# uvicorn을 사용하여 FastAPI 앱을 실행합니다
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]