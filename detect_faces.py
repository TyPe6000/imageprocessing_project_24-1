# MATLAB R2024a 환경 기준, Python 3.9, 3.10, 3.11 호환. 상세 하단 참고
# https://kr.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility
# Python에 boto3 설치 필요. 미설치 시 cmd에 하단 명령을 자신의 python.exe 설치 경로로 변경하여 적용.
# "C:\Program Files\Python311\python.exe" -m pip install boto3
import boto3
import json

# AWS 클라이언트 설정
def detect_faces(image_path, json_path):
    rekognition = boto3.client(
        'rekognition',
        # *aws에서 받은 access_key, secret_access_key 설정
        aws_access_key_id='MY_ACCESS_KEY',
        aws_secret_access_key='MY_SECRET_ACCESS_KEY',
        region_name='us-east-1'
    )
    
    with open(image_path, 'rb') as image:
        image_bytes = image.read()

    #얼굴 표정 분석
    response = rekognition.detect_faces(
        Image={'Bytes': image_bytes},
        Attributes=['ALL']
    )

    # 분석 결과 JSON 파일로 저장
    emotions_data = []
    for face_detail in response['FaceDetails']:
        emotions = {emotion['Type']: emotion['Confidence'] for emotion in face_detail['Emotions']}
        emotions_data.append(emotions)

    with open(json_path, 'w') as json_file:
        json.dump(emotions_data, json_file, indent=4)

    print(f"Emotion data saved to {json_path}")

