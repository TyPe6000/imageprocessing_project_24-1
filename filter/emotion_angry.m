function resultImage = emotion_angry(img, markImg)
    % 얼굴 검출기 객체 생성
    faceDetector = vision.CascadeObjectDetector();

    % 얼굴 검출
    bbox = step(faceDetector, img);

    % 사거리 마크 크기 조정 (10분의 1로 축소)
    scaleFactor = 0.1;
    resizedMarkImg = imresize(markImg, scaleFactor);

    % 배경 색상 (흰색) 투명화
    backgroundColor = [255, 255, 255]; % 배경이 흰색인 경우
    alphaMask = ~(resizedMarkImg(:,:,1) == backgroundColor(1) & ...
                  resizedMarkImg(:,:,2) == backgroundColor(2) & ...
                  resizedMarkImg(:,:,3) == backgroundColor(3));

    % 얼굴 영역에 대해 각 바운딩 박스마다 처리
    for i = 1:size(bbox, 1)
        % 얼굴 영역 추출
        face = bbox(i, :);
        face_img = img(face(2):face(2)+face(4)-1, face(1):face(1)+face(3)-1, :);

        % 그레이스케일 변환
        gray_face_img = rgb2gray(face_img);

        % 히스토그램 평활화
        equalized_img = histeq(gray_face_img);

        % Canny 엣지 검출
        edges = edge(equalized_img, 'Canny');

        % 모폴로지 연산을 통해 작은 노이즈 제거
        edges = imdilate(edges, strel('disk', 2));
        edges = imfill(edges, 'holes');
        edges = imerode(edges, strel('disk', 2));

        % 얼굴 윤곽선 검출
        boundaries = bwboundaries(edges);
        if ~isempty(boundaries)
            boundary = boundaries{1};
            mask = poly2mask(boundary(:,2), boundary(:,1), size(face_img, 1), size(face_img, 2));

            % 얼굴 내부 영역의 빨간색 채널 값 증폭
            face_img_red = face_img(:,:,1);
            face_img_red(mask) = min(255, 1.5 * face_img_red(mask));
            face_img(:,:,1) = face_img_red;

            % 원본 이미지에 수정된 얼굴 영역 적용
            img(face(2):face(2)+face(4)-1, face(1):face(1)+face(3)-1, :) = ...
                bsxfun(@times, img(face(2):face(2)+face(4)-1, face(1):face(1)+face(3)-1, :), uint8(~mask)) + ...
                bsxfun(@times, face_img, uint8(mask));

            % 사거리 마크를 얼굴 상단에 추가
            markHeight = size(resizedMarkImg, 1);
            markWidth = size(resizedMarkImg, 2);

            % 얼굴 상단에 위치 계산
            topLeftY = max(1, face(2) - markHeight);
            topLeftX = max(1, face(1) + round((face(3) - markWidth) / 2));

            % 마크를 이미지 경계를 벗어나지 않게 제한
            markEndY = min(size(img, 1), topLeftY + markHeight - 1);
            markEndX = min(size(img, 2), topLeftX + markWidth - 1);

            for y = 1:(markEndY - topLeftY + 1)
                for x = 1:(markEndX - topLeftX + 1)
                    % 사거리 마크 이미지의 배경 제외
                    if alphaMask(y, x)
                        img(topLeftY+y-1, topLeftX+x-1, :) = resizedMarkImg(y, x, :);
                    end
                end
            end
        end
    end

    resultImage = img;
end
