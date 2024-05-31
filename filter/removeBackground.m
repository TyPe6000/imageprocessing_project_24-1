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
