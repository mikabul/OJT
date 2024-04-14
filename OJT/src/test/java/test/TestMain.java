package test;

import com.ojt.util.Sha256;

public class TestMain {

	public static void main(String[] args) {
		Sha256 encoder = new Sha256();
		String str = "1234asdf";
		String hashString = encoder.encrypt(str);
		System.out.println(hashString);
		
	}

}