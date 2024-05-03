package km.cd.backend.challenge;


import km.cd.backend.user.User;

public class UserFixture {
    
    public static User user() {
        return User.builder()
            .email("example@example.com")
            .password("password123")
            .provider("local")
            .providerId("local123")
            .name("John Doe")
            .avatar("avatar.jpg")
            .role("ROLE_USER")
            .level(1)
            .xp(0)
            .point(0)
            .build();
    }
    
}
