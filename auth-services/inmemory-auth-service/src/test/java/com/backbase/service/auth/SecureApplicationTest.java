package com.backbase.service.auth;

import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@SpringBootTest(classes = {Application.class})
public class SecureApplicationTest {

    @Autowired
    private ApplicationContext context;

    private AuthenticationManager authenticationManager;

    @BeforeEach
    public void init() {
        this.authenticationManager = this.context.getBean(AuthenticationManager.class);
    }

    @Test
    public void shouldBeAuthenticatedAsAdmin() {
        assertTrue(authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken("admin", "admin")).isAuthenticated());
    }

    @Test
    public void shouldThrowBadCredentialsException() {
        assertThrows(BadCredentialsException.class, () ->
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken("admin", "wrong password")));
    }

    @AfterEach
    public void close() {
        SecurityContextHolder.clearContext();
    }
}