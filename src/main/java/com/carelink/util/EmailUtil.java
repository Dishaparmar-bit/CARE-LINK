package com.carelink.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

private static final String FROM_EMAIL =
        "carelinksupportteam@gmail.com";

private static final String APP_PASSWORD =
        "";

private static Session getSession() {

    Properties props = new Properties();

    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.starttls.required", "true");
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.debug", "true");

    return Session.getInstance(
            props,
            new Authenticator() {

                protected PasswordAuthentication getPasswordAuthentication() {

                    return new PasswordAuthentication(
                            FROM_EMAIL,
                            APP_PASSWORD
                    );
                }
            });
}

public static boolean sendOTP(
        String toEmail,
        String otp) {

    try {

        Message message =
                new MimeMessage(getSession());

        message.setFrom(
                new InternetAddress(FROM_EMAIL)
        );

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );

        message.setSubject(
                "CARE LINK OTP Verification"
        );

        message.setText(
                "Your OTP is: "
                + otp
                + "\n\nValid for 5 minutes."
        );

        Transport.send(message);

        return true;

    } catch (Exception e) {

        e.printStackTrace();

        return false;
    }
}

public static boolean sendWelcomeEmail(
        String toEmail,
        String fullName,
        String role) {

    try {

        Message message =
                new MimeMessage(getSession());

        message.setFrom(
                new InternetAddress(FROM_EMAIL)
        );

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );

        String subject = "";
        String emailBody = "";

        if ("ngo".equalsIgnoreCase(role)) {

            subject =
                    "NGO Registration Received - CARE LINK";

            emailBody =
                    "Hello " + fullName + ",\n\n" +

                    "Thank you for registering your NGO with CARE LINK.\n\n" +

                    "Your account has been created successfully and is currently under verification.\n\n" +

                    "NGO Status: PENDING VERIFICATION\n\n" +

                    "Our team will review your submitted details and certificate.\n" +
                    "Once approved, you will receive another email.\n\n" +

                    "After approval you can:\n" +
                    "- Create campaigns\n" +
                    "- Receive donations\n" +
                    "- Connect with volunteers\n" +
                    "- Manage beneficiaries\n\n" +

                    "Regards,\n" +
                    "CARE LINK Team";

        } else if ("volunteer".equalsIgnoreCase(role)) {

            subject =
                    "Welcome Volunteer - CARE LINK";

            emailBody =
                    "Hello " + fullName + ",\n\n" +

                    "Thank you for joining CARE LINK as a Volunteer.\n\n" +

                    "You are now part of a community dedicated to helping people in need.\n\n" +

                    "You can participate in campaigns and social activities.\n\n" +

                    "Every hour of service creates a difference.\n\n" +

                    "- CARE LINK Team";

        } else if ("donor".equalsIgnoreCase(role)) {

            subject =
                    "Welcome Donor - CARE LINK";

            emailBody =
                    "Hello " + fullName + ",\n\n" +

                    "Thank you for registering as a Donor on CARE LINK.\n\n" +

                    "Your contributions can help NGOs and communities achieve meaningful change.\n\n" +

                    "Together we can make every donation count.\n\n" +

                    "- CARE LINK Team";

        } else {

            subject =
                    "Welcome to CARE LINK";

            emailBody =
                    "Hello " + fullName + ",\n\n" +

                    "Your CARE LINK account has been created successfully.\n\n" +

                    "- CARE LINK Team";
        }

        message.setSubject(subject);
        message.setText(emailBody);

        Transport.send(message);

        return true;

    } catch (Exception e) {

        e.printStackTrace();

        return false;
    }
}

public static boolean sendNGOApprovalEmail(
        String toEmail,
        String ngoName) {

    try {

        Message message =
                new MimeMessage(getSession());

        message.setFrom(
                new InternetAddress(FROM_EMAIL)
        );

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );

        message.setSubject(
                "NGO Approved - CARE LINK"
        );

        message.setText(
                "Hello " + ngoName + ",\n\n" +

                "Congratulations!\n\n" +

                "Your NGO registration has been approved by CARE LINK.\n\n" +

                "You can now:\n" +
                "- Create campaigns\n" +
                "- Receive donations\n" +
                "- Connect with volunteers\n" +
                "- Manage beneficiaries\n\n" +

                "Welcome to CARE LINK.\n\n" +

                "- CARE LINK Team"
        );

        Transport.send(message);

        return true;

    } catch (Exception e) {

        e.printStackTrace();

        return false;
    }
}

public static boolean sendNGORejectionEmail(
        String toEmail,
        String ngoName) {

    try {

        Message message =
                new MimeMessage(getSession());

        message.setFrom(
                new InternetAddress(FROM_EMAIL)
        );

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );

        message.setSubject(
                "NGO Verification Update - CARE LINK"
        );

        message.setText(
                "Hello " + ngoName + ",\n\n" +

                "Your NGO verification request has been rejected.\n\n" +

                "Possible reasons:\n" +
                "- Invalid registration number\n" +
                "- Missing certificate\n" +
                "- Unclear uploaded document\n\n" +

                "Please review your information and register again.\n\n" +

                "- CARE LINK Team"
        );

        Transport.send(message);

        return true;

    } catch (Exception e) {

        e.printStackTrace();

        return false;
    }
}


}
