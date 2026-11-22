package com.tlahtolli.api.repository;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.tlahtolli.api.entity.EmailToken;

public interface EmailTokenRepository extends JpaRepository<EmailToken, Integer> {

    Optional<EmailToken> findByTokenHash(String tokenHash);

    /** Envíos recientes de un usuario (límite de reenvíos). */
    long countByUserIdAndCreatedAtAfter(Integer userId, LocalDateTime after);

    Optional<EmailToken> findFirstByUserIdOrderByCreatedAtDesc(Integer userId);

    /** Al pedir un token nuevo, los anteriores sin usar dejan de servir. */
    @Modifying
    @Query("update EmailToken t set t.usedAt = :now where t.userId = :userId and t.usedAt is null")
    int invalidateAll(@Param("userId") Integer userId, @Param("now") LocalDateTime now);

    // ── Restablecer contraseña: sus tokens se cuentan e invalidan aparte de los de verificación ──

    long countByUserIdAndPurposeAndCreatedAtAfter(Integer userId, String purpose, LocalDateTime after);

    Optional<EmailToken> findFirstByUserIdAndPurposeOrderByCreatedAtDesc(Integer userId, String purpose);

    @Modifying
    @Query("update EmailToken t set t.usedAt = :now where t.userId = :userId and t.purpose = :purpose and t.usedAt is null")
    int invalidateByPurpose(@Param("userId") Integer userId, @Param("purpose") String purpose, @Param("now") LocalDateTime now);
}
