package com.juleswhite.module1;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class QRBankUtil {
    public static String getVietQRUrl(String bankId, String accountNumber, long amount, String description, String accountName) throws UnsupportedEncodingException {
        return String.format(
            "https://img.vietqr.io/image/%s-%s-compact2.png?amount=%d&addInfo=%s&accountName=%s",
            bankId, accountNumber, amount,
            URLEncoder.encode(description, "UTF-8"),
            URLEncoder.encode(accountName, "UTF-8")
        );
    }
} 