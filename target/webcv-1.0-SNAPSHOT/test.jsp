<%-- 
    Document   : test
    Created on : Nov 30, 2014, 8:49:05 PM
    Author     : Saboteur
--%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    // Init my email address to receive email
    String to = "websliem@gmail.com";
    final String uid = "websliem@gmail.com";
    final String pwd = "taokobiet";

    String result = "";
    boolean isValid = true;
    String name = request.getParameter("contactName");
    String email = request.getParameter("contactEmail");
    String subject = request.getParameter("contactSubject");
    String contact_message = request.getParameter("contactMessage");
    // Check valid info
    if (name == null || name.length() < 1) {
        result += "Please enter your name.<br>";
        isValid = false;
    }
    if (email != null) {
        String pattern = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
        if (!Pattern.matches(pattern, email)) {
            result += "Please enter a valid email address.<br>";
            isValid = false;
        }
    } else if(email == null || email.length() < 1){
        result += "Please enter your email.<br>";
        isValid = false;
    }

    if (subject == null || subject.length() < 5) {
        subject = "Contact Form Submission";
        isValid = false;
    }
    if (contact_message == null || contact_message.length() < 15) {
        result += "Please enter your message. It should have at least 15 characters.";
        isValid = false;
    }
    if(isValid){
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        //props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // Get the default Session object.
        Session sessione = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(uid, pwd);
            }
        });

        try {
            // Create a default MimeMessage object.
            Message message = new MimeMessage(sessione);
            message.setFrom(new InternetAddress(email));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(to));
                    subject = "[Personal website] " + subject;
            message.setSubject(subject);
            message.setText(contact_message);

            Transport.send(message);
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            String str = "OK";
            response.getWriter().write(str.replaceAll("\\s+",""));
            //out.print("OK");
        } catch (MessagingException mex) {
            /*response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            String str = "OK";
            response.getWriter().write(str.replaceAll("\\s+",""));*/
            out.print("Unexpected Error: <br>");
            out.print("Reload the page to complete your action.");
            mex.printStackTrace();
        }
    }else{
    out.println("Error:<br>");
    out.println(result);
    }

%>