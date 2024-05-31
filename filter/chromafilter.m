function resultImage = chromafilter(image)
    % 배경 이미지 경로
    backImagePath = 'surprise.jpg';
    
    % 배경 이미지 읽기
    backImage = imread(backImagePath);
    
    % 배경 제거
    backimage = removeBackground(image); 

    % 크로마키 합성
    resultImage = chromakey(backimage, backImage);
end

function resultImage = removeBackground(image)
    % 이미지를 회색조로 변환
    grayImage = rgb2gray(image);
    
    % Canny 에지 검출 적용
    edges = edge(grayImage, 'Canny');
    
    % 에지를 기반으로 마스크 생성
    % 마스크를 부드럽게 하기 위해 모폴로지 연산 사용
    se = strel('disk', 5);
    mask = imdilate(edges, se);
    mask = imfill(mask, 'holes');
    mask = imerode(mask, se);
    
    % 마스크를 RGB로 변환
    mask = repmat(mask, [1, 1, 3]);
    
    % 원본 이미지를 복사하여 결과 이미지 초기화
    resultImage = image;
    
    % 배경을 녹색으로 설정
    greenBackground = uint8(cat(3, 0 * ~mask(:,:,1), 255 * ~mask(:,:,2), 0 * ~mask(:,:,3)));
    resultImage(~mask) = greenBackground(~mask);
end

function chromakey = chromakey(faceImage, backImage)
    % 배경 이미지의 크기를 전경 이미지(faceImage)와 동일하게 조정합니다.
    backImage = imresize(backImage, [size(faceImage, 1), size(faceImage, 2)]);

    % 크로마키 색상 선택 (얼굴 이미지의 배경색을 고려하여 선택합니다.)
    chromaKeyColor = [0, 255, 0]; % 녹색 배경 (RGB 형식)

    % 크로마키 마스크 생성
    chromaKeyMask = createChromaKeyMask(faceImage, chromaKeyColor);

    % 크로마키 마스크를 사용하여 얼굴 이미지와 배경 이미지를 합성합니다.
    resultImage = blendImages(faceImage, backImage, chromaKeyMask);

    % 결과 이미지를 반환합니다.
    chromakey = resultImage;
end

function chromaKeyMask = createChromaKeyMask(image, chromaKeyColor)
    % RGB 이미지를 HSV 색 공간으로 변환
    hsvImage = rgb2hsv(image);

    % 크로마키 색상을 HSV로 변환
    chromaKeyColor_hsv = rgb2hsv(reshape(chromaKeyColor, [1, 1, 3]));

    % 크로마키 색상 범위를 정의합니다. (예: 채도 및 명도에 대한 허용 범위 포함)
    hueTolerance = 0.1; % 색상 허용 범위
    saturationTolerance = 0.3; % 채도 허용 범위

    % 크로마키 마스크 생성
    chromaKeyMask = (abs(hsvImage(:,:,1) - chromaKeyColor_hsv(:,:,1)) <= hueTolerance) & ...
                    (abs(hsvImage(:,:,2) - chromaKeyColor_hsv(:,:,2)) <= saturationTolerance);

    % 크로마키 마스크를 이미지 크기에 맞게 조정
    chromaKeyMask = imresize(chromaKeyMask, [size(image, 1), size(image, 2)]);
end

function resultImage = blendImages(foreground, background, mask)
    % 마스크의 크기를 전경 이미지와 동일하게 조정
    mask = imresize(mask, [size(foreground, 1), size(foreground, 2)]);

    % 크로마키 마스크의 반대를 취하여 배경 부분을 선택
    maskedForeground = foreground .* uint8(~mask);

    % 배경 이미지를 선택
    maskedBackground = background .* uint8(mask);

    % 합성된 이미지 생성
    resultImage = maskedForeground + maskedBackground;
end
