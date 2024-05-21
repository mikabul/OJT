package test;

import java.util.regex.Pattern;

import com.ojt.util.Sha256;

public class TestMain {

	public static void main(String[] args) {
		Sha256 encoder = new Sha256();
		
		String str = " ";
		
		String hashedString = encoder.encode(str);
		System.out.println(hashedString);
	}

}