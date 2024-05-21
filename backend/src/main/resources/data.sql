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
VALUES (true, '1234', '국민대 소융 1일 1헬스 챌린지', '건강을 위해서라면 헬스는 필수입니다. 특히 우리와 같은 개발자들은 거북목이 고질병이잖아요. 웨이트 운동을 통해 짧아진 가슴근육을 늘려주며 거북목을 완치해봐요 👊\n3주간 1일 1헬스 도전해보자고요!\n(*국민대 소융 학생분들만 참여가능해요!)', 3,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 21 DAY), '매일', 1, 24,
        '헬스를 마친 자신의 사진을 루틴업Ai가 요청한 포즈와 함께 찍어주세요!\n🚫본 챌린지는 갤러리 사용이 가능한 챌린지입니다. 단 루틴업AI를 통한 인증이 되어야만 통과가 되니 부정행위는 금물입니다', true, 25,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/12.png',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/11.png',
        '진행중', 'HAND_GESTURE', 'EXERCISE', 21),

       (true, '1234', '주 4회 알고리즘 도전기', '<네이버 입사를 위한 취준러들의 알고리즘 공부 챌린지> 날이 갈수록 어려워지는 IT 채용시장이지만 우리 함께 으샤으샤 이겨내봐요🔥', 5,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 35 DAY), '주 4회', 0, 24,
        '자신이 공부하고 있는 사진을 루틴업Ai가 요청한 포즈와 함께 올려주세요~\n갤러리 사용 안됩니다~ 실시간 갓생을 올려주세요! ', false, 4,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/15.png',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/14.png',
        '진행중', 'GITHUB_COMMIT', 'STUDY', 35),

       (true, "1234", '회기 수영장 오후반 수영연습', '회기수영장 오후반 여러분 우리 함께 실력을 키워보자구요! 주 3회 자유수영으로 실력 업그레이드 합시다.', 2,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), '주 3회', 0, 24,
        '수영장 락커키와 인증샷을 찍어주세요! 손인증을 해주셔야합니다. 갤러리 사용 됩니다~ ', true, 100,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/18.png',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/19.png',
        '진행중', 'HAND_GESTURE', 'EXERCISE', 14),

       (false, null, '하루 한번 하늘보기', '바쁘다바빠 현대사회 !! 출근-직장-퇴근 일상이 반복인 요즘.. 하늘을 우러러 본 지가 너무 오래됐네요. 주 5일은 우리 10분이상 하늘을 바라보며 쉼을 가집시다.', 6,
        DATE_ADD(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 42 DAY), '주 5회', 0, 24,
        '하늘과 함께 Ai손증샷을 찍어주세요. 갤러리 사용은 불가능해요. 3초라도 아니.. 10초라도 하늘을 바라보는 시간을 꼭 갖자구요!', false, 1000,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/9.png',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/8.png',
        '진행전', 'HAND_GESTURE', 'EATING', 42),

       (true, '1234', '시작의기술 완독챌린지', '시작의기술 완독을 목표로 하는 이들의 챌린지! 하루 10분 이상 독서하며 그날의 감상을 함께 나누어요. 생각의 깊이가 날이 갈수록 달라질 거예요!', 4,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 28 DAY), '매일', 0, 24,
        '읽은 책을 커뮤니티에 올려주세요! 그 날의 감상평을 나누며 소통합니다.', true, 10,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/3.png',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/2.png',
        '진행중', 'HAND_GESTURE', 'STUDY', 28),

       (true, '1234', '감사챌린지', '매일 10가지 이상 감사하며 긍정의 힘을 느끼는 루티너가 되어보아요 ✨', 3,
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 21 DAY), '매일', 0, 24,
        '그 날 나를 행복하게 하는 순간을 담아주세요! 사진의 종류는 상관없습니다~ 커뮤니티에 감사하는 10가지를 함께 적어서 포스팅해주세요. 함께 보고 따뜻한 일상을 나누어 더 행복해집시다~!', true, 20,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/6.png',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/5.png',
        '진행중', 'HAND_GESTURE', 'EXERCISE', 21),


       (false, null, '6주동안 다이어트 성공하기!', '같이 다이어트에 성공해봐요! 1주에 한번 자신의 몸무게를 인증해주세요.', 6,
        DATE_SUB(CURDATE(), INTERVAL 43 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), '주 1회', 0, 24,
        '몸무게를 볼 수 있는 사진을 찍어주세요!', false, 100,
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/14.png',
        'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/14.png',
        '진행완료', 'HAND_GESTURE', 'EXERCISE', 42);

INSERT INTO challenge_challenge_image_paths (challenge_id, challenge_image_paths)
VALUES (1, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/10.png'),
       (2, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/13.png'),
       (3, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/17.png'),
       (4, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/7.png'),
       (5, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/1.png'),
       (6, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/4.png'),
       (7, 'https://routineup-s3.s3.ap-northeast-2.amazonaws.com/sample/16.png'),

INSERT INTO participants (challenge_id, user_id, is_owner, target_name, receiver_number, determination)
VALUES (1, 1, true, NULL, NULL, NULL),
       (2, 1, true, NULL, NULL, NULL),
       (3, 2, true, NULL, NULL, NULL),
       (4, 1, true, NULL, NULL, NULL),
       (5, 2, true, NULL, NULL, NULL),
       (6, 1, true, NULL, NULL, NULL),
       (7, 2, true, NULL, NULL, NULL),

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
