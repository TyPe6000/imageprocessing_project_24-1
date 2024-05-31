function resultImage = emotion_disgusted(img)
    % 색 반전
    inverted_img = imcomplement(img);

    % 이미지 크기 가져오기
    [rows, cols, ~] = size(inverted_img);

    % 웨이브 효과 적용
    % 파라미터 설정
    wave_amplitude = 5; % 웨이브의 진폭
    wave_frequency = 0.01; % 웨이브의 주파수

    % 웨이브 변형
    [X, Y] = meshgrid(1:cols, 1:rows);
    wave = wave_amplitude * sin(2 * pi * wave_frequency * Y);
    X_new = X + wave;

    % X_new가 정수가 되도록 보정
    X_new = round(X_new);

    % 이미지의 범위를 벗어나는 값을 처리
    X_new(X_new < 1) = 1;
    X_new(X_new > cols) = cols;

    % 웨이브 변형을 적용한 새로운 이미지 생성
    warped_img = zeros(size(inverted_img), 'uint8');
    for channel = 1:size(inverted_img, 3)
        for r = 1:rows
            for c = 1:cols
                warped_img(r, c, channel) = inverted_img(r, X_new(r, c), channel);
            end
        end
    end

    resultImage = warped_img;
end
