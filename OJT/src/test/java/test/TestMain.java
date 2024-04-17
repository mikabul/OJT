package test;

import java.util.regex.Pattern;

public class TestMain {

	public static void main(String[] args) {
		String regex = "^\\d{4}(0[1-9]|1[0-2])(0[1-9]|[1-2]\\d|3[0-1])$";
		String testRrn = "19980618";
		System.out.println(Pattern.matches(regex, testRrn));
	}

}