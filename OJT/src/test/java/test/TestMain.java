package test;

import java.time.LocalDate;

public class TestMain {

	public static void main(String[] args) {
		String dateStr = "2000-02-29";
		try {
			LocalDate date = LocalDate.parse(dateStr);
			System.out.println(date);
			System.out.println("올바른 날짜입니다.");
		} catch (Exception e) {
			System.out.println("잘못된 날짜입니다.");
		}
	}

}