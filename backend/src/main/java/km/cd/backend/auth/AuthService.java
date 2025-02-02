package km.cd.backend.auth;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.jwt.JwtTokenProvider;
import km.cd.backend.common.jwt.JwtTokenResponse;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.repository.UserRepository;
import km.cd.backend.user.dto.UserLogin;
import km.cd.backend.user.dto.UserRegister;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    private User emailExists(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    @Transactional
    public User register(final UserRegister userRequest) {
        if (emailExists(userRequest.getEmail()) != null) {
            throw new CustomException(ExceptionCode.ALREADY_SIGNED_UP_ERROR);
        }
        String encodedPassword = passwordEncoder.encode(userRequest.getPassword());

        User user = User.builder()
                .email(userRequest.getEmail())
                .password(encodedPassword)
                .name(userRequest.getName())
                .build();
        return userRepository.save(user);
    }

    public JwtTokenResponse login(UserLogin userLogin) {
        String email = userLogin.getEmail();

        User user = emailExists(email);
        if (user == null) {
            throw new CustomException(ExceptionCode.INVALID_EMAIL_PASSWORD_ERROR);
        }

        if (!passwordEncoder.matches(userLogin.getPassword(), user.getPassword())) {
            throw new CustomException(ExceptionCode.INVALID_EMAIL_PASSWORD_ERROR);
        }

        String accessToken = jwtTokenProvider.generateAccessToken(
                user.getId(),
                user.getEmail(),
                user.getName(),
                Collections.singleton(new SimpleGrantedAuthority(user.getRole()))
        );

        return JwtTokenResponse.builder()
                .accessToken(accessToken)
                .build();
    }

}
