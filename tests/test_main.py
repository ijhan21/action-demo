from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_root():
    """헬스체크 테스트"""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["message"] == "TaskFlow MVP is running!"


def test_create_todo():
    """TODO 생성 테스트"""
    response = client.post("/todos", json={
        "title": "테스트",
        "description": "pytest 테스트"
    })
    assert response.status_code == 201
    assert response.json()["title"] == "테스트"
    assert response.json()["completed"] == False


def test_complete_second_todo():
    """
    Tiger의 버그를 잡는 테스트!
    두 번째 TODO 완료가 제대로 되는지 확인
    """
    # 두 개 생성
    client.post("/todos", json={"title": "첫번째"})
    response = client.post("/todos", json={"title": "두번째"})
    todo_id = response.json()["id"]
    
    # 두번째 완료 처리
    result = client.patch(f"/todos/{todo_id}/complete")
    
    assert result.status_code == 200
    assert result.json()["completed"] == True