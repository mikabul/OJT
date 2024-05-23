package com.ojt.config;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScans;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer;

import com.ojt.bean.AuthorityBean;
import com.ojt.service.AuthorityService;
import com.ojt.service.MemberDetailService;
import com.ojt.util.Sha256;

@Configuration
@EnableWebSecurity
@ComponentScans({
    @ComponentScan("com.ojt.controller"),
    @ComponentScan("com.ojt.service"),
    @ComponentScan("com.ojt.dao"),
    @ComponentScan("com.ojt.util")
})
@MapperScan("com.ojt.mapper")
@EnableMethodSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter{
	
	@Autowired
	private MemberDetailService memberDetailService;
	
	@Autowired
	private Sha256 encoder;
	
	@Autowired
	private AuthorityService authorityService;
	
	@Override
	public void configure(WebSecurity web) throws Exception {
		// 권한 관계없이 resources로는 모두 접근 가능하게
		web.ignoring().antMatchers("/resources/**");
	}
	
	/*
	 * 사용자 검증에 사용할 서비스와
	 * 비밀번호 인코더를 설정
	 */
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(memberDetailService).passwordEncoder(encoder);
	}

	/*
	 * csrf 비활성화
	 * '/', '/login'은 누구나 접근 가능하게
	 * 그 외 모든 요청은 권한에 따라 접근 가능
	 */
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		
		http
        .csrf().disable()
        .formLogin()
            .loginPage("/login")
            .loginProcessingUrl("/login")
            .defaultSuccessUrl("/main", true)
            .failureUrl("/login?error=true")
            .usernameParameter("memberId")
            .passwordParameter("memberPW")
            .permitAll()
        .and()
        .logout()
            .logoutUrl("/logout")
            .logoutSuccessUrl("/")
        .and()
        .exceptionHandling()
        	.accessDeniedPage("/access-denied");
		
		ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry obj = http.authorizeRequests();
		obj.antMatchers("/", "/login", "/error").permitAll();
		
		ArrayList<AuthorityBean> authorityList = authorityService.getAllAuthority();
		
		for (AuthorityBean authorityBean : authorityList) {
			obj.antMatchers(authorityBean.getMenuUrl()).hasAnyRole(authorityBean.getAuthorityNameList());
		}
		
		obj.anyRequest().denyAll();
		
	}
	
}
