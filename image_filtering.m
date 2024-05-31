% *프로젝트 디렉토리 경로 설정
projectDir = 'MY_PROJECT_DIRECTORY'; % 나의 경로로 설정 필요

% 필터 함수들이 저장된 디렉토리 경로 추가
addpath(fullfile(projectDir, 'filter'));

% MATLAB에서 Python 코드 실행
% Python 모듈 임포트
py.importlib.import_module('detect_faces');

% *이미지와 JSON 경로 설정
image_path = fullfile(projectDir, 'sample', 'SAMPLEIMAGE'); % 목표 대상 이미지 이름으로 설정 필요
json_path = fullfile(projectDir, 'output', 'emotions_data.json');

% Python 함수 호출(감정 인식 후 json 파일로 값 저장)
py.detect_faces.detect_faces(image_path, json_path);

% JSON 파일 읽기
emotionsData = jsondecode(fileread(json_path));

% 입력 이미지 읽기
inputImage = imread(image_path);

% 배경 이미지 경로 설정
happyBackground = fullfile(projectDir, 'FilterBG', 'happy_background.JPG');
sadBackground = fullfile(projectDir, 'FilterBG', 'sad_background.JPG');
surprisedBackground = fullfile(projectDir, 'FilterBG', 'surprise_background.jpg');
angryMark = imread(fullfile(projectDir, 'FilterBG', 'angry_mark.jpg'));


% 감정 데이터 분석 및 필터 적용
for i = 1:length(emotionsData)
    emotions = emotionsData(i);
    emotionNames = fieldnames(emotions);
    
    % 가장 강한 감정 찾기
    maxConfidence = -Inf;
    maxEmotion = '';
    for j = 1:length(emotionNames)
        currentEmotion = emotionNames{j};
        currentConfidence = emotions.(currentEmotion);
        if currentConfidence > maxConfidence
            maxConfidence = currentConfidence;
            maxEmotion = currentEmotion;
        end
    end
    
    % 감정에 따른 필터 적용
    switch maxEmotion
        case 'HAPPY'
            filteredImage = emotion_happy(inputImage, happyBackground);
        case 'SAD'
            filteredImage = emotion_sad(inputImage, sadBackground);
        case 'ANGRY'
            filteredImage = emotion_angry(inputImage, angryMark);
        case 'SURPRISED'
            filteredImage = emotion_surprised(inputImage, surprisedBackground);
        case 'DISGUSTED'
            filteredImage = emotion_disgusted(inputImage);
        otherwise
            filteredImage = inputImage;
    end

    % 현재 시간 가져오기
    currentTime = datetime('now', 'Format', 'yyyyMMdd_HHmmss');
    currentTimeStr = datestr(currentTime, 'yyyymmdd_HHMMSS');
   
    % 필터 적용된 이미지 저장
    outputPath = fullfile(projectDir, 'output', sprintf('output_image_%s.jpg', currentTimeStr));
    imwrite(filteredImage, outputPath);

    % Figure로 원본 이미지와 필터 적용된 이미지 및 감정 정보 출력
    fig = figure;
    
    % 원본 이미지
    subplot(1, 3, 1);
    imshow(inputImage);
    title('Original Image');
    
    % 필터 적용된 이미지
    subplot(1, 3, 2);
    imshow(filteredImage);
    title(sprintf('Filtered Image (%s)', maxEmotion));
    
    % 감정 정보 텍스트 출력
    subplot(1, 3, 3);
    text(0.5, 0.5, sprintf('Emotion: %s\nConfidence: %.2f%%', maxEmotion, maxConfidence), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 12);
    axis off; % 축을 숨깁니다.
    title('Emotion Info');

    % Figure를 이미지 파일로 저장
    figurePath = fullfile(projectDir, 'output', sprintf('figure_output_%s.png', currentTimeStr));
    saveas(fig, figurePath);
end
