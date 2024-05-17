package com.ojt.config;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScans;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

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
@PropertySource("/WEB-INF/properties/db.properties")
public class SecurityConfig extends WebSecurityConfigurerAdapter{
	
	@Value("${db.classname}")
	String classname;
	@Value("${db.url}")
	String url;
	@Value("${db.username}")
	String username;
	@Value("${db.password}")
	String password;

	@Autowired
	private MemberDetailService memberDetailService;
	
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
		auth.userDetailsService(memberDetailService).passwordEncoder(encoder());
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
        .authorizeRequests()
            .antMatchers("/", "/login").permitAll()
            .anyRequest().authenticated()
        .and()
        .formLogin()
            .loginPage("/")
            .loginProcessingUrl("/login")
            .defaultSuccessUrl("/main", true)
            .failureUrl("/login?error=true")
            .usernameParameter("memberId")
            .passwordParameter("memberPW")
            .permitAll()
        .and()
        .logout()
            .logoutUrl("/logout")
            .logoutSuccessUrl("/");
	}
	
	@Bean
	public BasicDataSource dataSource() {
		BasicDataSource source = new BasicDataSource();
		source.setDriverClassName(classname);
		source.setUrl(url);
		source.setUsername(username);
		source.setPassword(password);
		
		return source;
	}
	
	@Bean
	public DataSourceTransactionManager transactionManager(BasicDataSource source) {
		return new DataSourceTransactionManager(source);
	}
	
	@Bean
	public SqlSessionFactory factory(BasicDataSource source) throws Exception {
		
		SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
		factoryBean.setDataSource(source);
		factoryBean.setConfigLocation(new PathMatchingResourcePatternResolver().getResource("classpath:mybatis-config.xml"));
		SqlSessionFactory factory = factoryBean.getObject();
		
		return factory;
		
	}
	
	@Bean
	public Sha256 encoder() {
		return new Sha256();
	}
}
