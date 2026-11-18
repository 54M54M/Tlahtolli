package com.tlahtolli.api.security;

import java.util.List;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.tlahtolli.api.repository.UserRepository;

/**
 * Usuarios que pueden entrar al monitor: solo los de ta_users con role = 'admin'.
 * A un usuario normal se le responde igual que a uno inexistente ("credenciales
 * incorrectas"), para no revelar qué cuentas son de administrador.
 */
@Service
public class AdminUserDetailsService implements UserDetailsService {

    private final UserRepository userRepo;

    public AdminUserDetailsService(UserRepository userRepo) {
        this.userRepo = userRepo;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepo.findByUsername(username)
                .filter(com.tlahtolli.api.entity.User::isAdmin)
                .filter(com.tlahtolli.api.entity.User::hasPassword)
                .map(u -> User.withUsername(u.getUsername())
                        .password(u.getPasswordHash())
                        .authorities(List.of(new SimpleGrantedAuthority("ROLE_ADMIN")))
                        .build())
                .orElseThrow(() -> new UsernameNotFoundException("credenciales incorrectas"));
    }
}
