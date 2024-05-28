% MATLAB에서 Python 코드 실행
% Python 모듈 임포트
py.importlib.import_module('detect_faces');

% 이미지와 JSON 경로 설정
image_path = ['1000005031.jpg'];
json_path = 'emotions_data.json';

% Python 함수 호출(감정 인식 후 json 파일로 값 저장)
py.detect_faces.detect_faces(image_path, json_path);

% JSON 파일 읽기
emotionsData = jsondecode(fileread(json_path));

% 입력 이미지 읽기
inputImage = imread(image_path);

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
    
    % 감정에 따른 필터 적용(*샘플 필터에서 제작한 필터로 변경할 것)
    switch maxEmotion
        case 'HAPPY'
            filteredImage = apply_gaussian_filter(inputImage);
        case 'SAD'
            filteredImage = apply_sharpen_filter(inputImage);
        case 'ANGRY'
            filteredImage = apply_edge_filter(inputImage);
        otherwise
            filteredImage = inputImage;
    end

    % 현재 시간 가져오기
    currentTime = datetime('now', 'Format', 'yyyyMMdd_HHmmss');
    currentTimeStr = datestr(currentTime, 'yyyymmdd_HHMMSS');

    % 필터 적용된 이미지 저장
    outputPath = sprintf('output_image_%s.jpg', currentTimeStr);
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
    figurePath = sprintf('figure_output_%s.png', currentTimeStr);
    saveas(fig, figurePath);
end
