package km.cd.backend.jwt;

import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.stream.Collectors;

@Component
public class JwtTokenProvider {

    private final Key jwtSecret;
    private final Integer jwtExpirationInMs;
    private final PrincipalDetailsService principalDetailsService;

    private static final String CLAIM_AUTHORITIES = "authorities";
    private static final String DELIMITER = ",";

    public JwtTokenProvider(
            @Value("${jwt.secret}") String jwtSecretStr,
            @Value("${jwt.expiration_in_ms}") Integer jwtExpirationInMs,
            PrincipalDetailsService principalDetailsService
    ) {
        this.jwtSecret = Keys.hmacShaKeyFor(jwtSecretStr.getBytes());
        this.jwtExpirationInMs = jwtExpirationInMs;
        this.principalDetailsService = principalDetailsService;
    }

    public String generateToken(Authentication authentication) {
        PrincipalDetails principalDetails = (PrincipalDetails) authentication.getPrincipal();
        String authorities = principalDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(DELIMITER));

        long now = System.currentTimeMillis();

        return Jwts.builder()
                .setSubject(principalDetails.getUsername())
                .claim(CLAIM_AUTHORITIES, authorities)
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + jwtExpirationInMs))
                .signWith(jwtSecret, SignatureAlgorithm.HS512)
                .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(jwtSecret).build().parseClaimsJws(token);
            return true;
        } catch (JwtException e) {
            return false;
        }
    }

    public Authentication getAuthentication(String token) {
        String email = Jwts.parserBuilder()
                .setSigningKey(jwtSecret)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject()
                .toString();
        PrincipalDetails principalDetails = principalDetailsService.loadUserByUsername(email);
        return new UsernamePasswordAuthenticationToken(principalDetails, null, principalDetails.getAuthorities());
    }
}

