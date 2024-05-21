INSERT INTO users (id, email, name, provider, provider_id, avatar, role, created_date, point, github_username)
VALUES (1, 'as221323@gmail.com', '혜은', 'google', '100824832015308398604',
        'https://lh3.googleusercontent.com/a/ACg8ocL4-IfGstdB1Y4vJj3Iv7PWEp9L9m73tBS9yQ32VQiGfGB-fMeGkA=s96-c',
        'ROLE_USER', '2024-05-21 13:00:23.589047', 0, NULL),
       (2, 'ehensnfl@gmail.com', '홍석주', 'google', '110427972627923433511',
        'https://lh3.googleusercontent.com/a/ACg8ocId6oc4SApxyZJSqAeeSy6W0Ex7uReuU1R2Ezwawdu5GhPowz4=s96-c',
        'ROLE_USER', '2024-05-21 16:10:26.426552', 0, NULL);


INSERT INTO challenges (is_private, private_code, challenge_name, challenge_explanation, challenge_period,
                        start_date, end_date, certification_frequency, certification_start_time, certification_end_time,
                        certification_explanation, is_gallery_possible, maximum_people, failed_verification_image,
                        successful_verification_image, status, certification_type, challenge_category,
                        total_certification_count)
VALUES (true, '1234', '혁규 1일 1헬스 챌린지', '건강을 위해서라면 헬스는 필수입니다. 3주간 1일 1헬스 도전해보자고요!', 3,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 21 DAY), '매일', 1, 24,
        '헬스를 마친 자신의 사진을 찍어주세요!', false, 25,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행중', 'HAND_GESTURE', 'EXERCISE', 21),

       (true, '1234', '석주의 커밋 도전기', '난 네이버 사장이 되겠어', 5,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 35 DAY), '주 4회', 0, 24,
        'github 커밋 인증으로 합니다 ~', false, 4,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행중', 'GITHUB_COMMIT', 'STUDY', 35),

       (false, null, '같이 수영하러 가실분~', '저는 수영 좀 치는데 같이 수영하실 분 계실까요~ 2주간 주 3회 진행합니다.', 2,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), '주 3회', 0, 24,
        '수영하고 인증샷을 찍어주세요! 손인증을 해주셔야합니다.', true, 100,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행중', 'HAND_GESTURE', 'EXERCISE', 14),

       (false, null, '닭가슴살을 좋아해', '닭가슬살 패실 분 구함', 6,
        DATE_ADD(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 42 DAY), '주 5회', 0, 24,
        '닭가슴살을 먹고 사진을 찍어주세요!', false, 1000,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행전', 'HAND_GESTURE', 'EATING', 42),

       (true, '1234', '진혁의 매일 독서 챌린지', '매일 책 읽기 도전!', 4,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 28 DAY), '매일', 0, 24,
        '읽은 책을 커뮤니티에 올려주세요!', false, 10,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행중', 'HAND_GESTURE', 'STUDY', 28),

       (true, '1234', '소라의 하루 1요가', '요가로 건강해지기', 3,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 21 DAY), '매일', 0, 24,
        '요가 자세를 취한 사진을 찍어주세요!', false, 20,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행중', 'HAND_GESTURE', 'EXERCISE', 21),

       (false, null, '1일 1커밋 챌린지', '취업 준비를 위해서 1일 1커밋에 도전합니다!', 5,
        DATE_SUB(CURDATE(), INTERVAL 35 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), '매일', 0, 24,
        '오늘의 커밋 내역을 볼 수 있는 사진을 올려주세요!', true, 50,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행완료', 'HAND_GESTURE', 'EXERCISE', 35),

       (false, null, '6주동안 다이어트 성공하기!', '같이 다이어트에 성공해봐요! 1주에 한번 자신의 몸무게를 인증해주세요.', 6,
        DATE_SUB(CURDATE(), INTERVAL 43 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), '주 1회', 0, 24,
        '몸무게를 볼 수 있는 사진을 찍어주세요!', false, 100,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609',
        '진행완료', 'HAND_GESTURE', 'EXERCISE', 42);

INSERT INTO challenge_challenge_image_paths (challenge_id, challenge_image_paths)
VALUES (1, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'),
       (2, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'),
       (3, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'),
       (4, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'),
       (5, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'),
       (6, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'),
       (7, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'),
       (8, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609');

INSERT INTO participants (challenge_id, user_id, is_owner, target_name, receiver_number, determination)
VALUES (1, 1, true, NULL, NULL, NULL),
       (2, 1, true, NULL, NULL, NULL),
       (3, 1, true, NULL, NULL, NULL),
       (4, 1, true, NULL, NULL, NULL),
       (5, 1, true, NULL, NULL, NULL),
       (6, 1, true, NULL, NULL, NULL),
       (7, 2, true, NULL, NULL, NULL),
       (8, 1, true, NULL, NULL, NULL);

INSERT INTO posts (is_rejected, author_id, challenge_id, created_date, modified_date, title, content, image)
SELECT
    false,
    2,
    7,
    DATE_SUB(CURDATE(), INTERVAL 43 DAY) + INTERVAL ((RAND() * 6) + 1) * 7 DAY, -- 무작위 생성
    null,
    CONCAT('제목', FLOOR(RAND() * 100)), -- 임의의 제목
    CONCAT('내용', FLOOR(RAND() * 100)), -- 임의의 내용
    'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'
FROM
    information_schema.tables
LIMIT
    5;

INSERT INTO posts (is_rejected, author_id, challenge_id, created_date, modified_date, title, content, image)
SELECT
    false,
    1,
    8,
    DATE_SUB(CURDATE(), INTERVAL 43 DAY) + INTERVAL ((RAND() * 6) + 1) * 7 DAY, -- 무작위 생성
    null,
    CONCAT('제목', FLOOR(RAND() * 100)), -- 임의의 제목
    CONCAT('내용', FLOOR(RAND() * 100)), -- 임의의 내용
    'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609'
FROM
    information_schema.tables
LIMIT
    5
