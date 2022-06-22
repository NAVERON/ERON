#! /usr/bin/env python3 
# -*- coding: utf-8 -*-

# This little project is hosted at: <https://gist.github.com/1455741>
# Copyright 2011-2020 Álvaro Justen [alvarojusten at gmail dot com]
# License: GPL <http://www.gnu.org/copyleft/gpl.html>

import os 
import datetime 
import smtplib 
from email.mime.multipart import MIMEMultipart 
from email.mime.base import MIMEBase 
from email.mime.text import MIMEText 
from email.header import Header 
from email import encoders  
from mimetypes import guess_type 
import argparse 



class Email(object):
    def __init__(self, from_, to, subject, 
                message, message_type='plain', message_encoding='utf-8', 
                cc=None, attachments=None ):
        self.email = MIMEMultipart()
        self.email['From'] = self.get_email(from_)  # formated  name:<email_addr>
        self.email['To'] = self.get_email(to)  # formated   name:<email_addr>
        self.email['Subject'] = Header(subject, message_encoding)
        if cc is not None : 
            self.email['Cc'] = self.get_email(cc)
        text = MIMEText(message, message_type, message_encoding)
        self.email.attach(text)
        if attachments is not None:
            for filename in attachments:
                mimetype, file_encoding = guess_type(filename) 
                if mimetype == None : 
                    mimetype = "text/plain" 
                mimetype = mimetype.split('/', 1)
                fp = open(filename, 'rb')
                attachment = MIMEBase(mimetype[0], mimetype[1])
                attachment.set_payload(fp.read())
                fp.close()
                encoders.encode_base64(attachment)
                attachment.add_header('Content-Disposition', 'attachment',
                                      filename=os.path.basename(filename))
                self.email.attach(attachment)

    def get_email(self, email):
        if '<' in email:
            data = email.split('<')
            email = data[1].split('>')[0].strip()
        return email.strip()
    
    def __str__(self):
        return self.email.as_string()

class EmailConnection(object):
    def __init__(self, server, username, password):
        if ':' in server:
            data = server.split(':')
            self.server = data[0]
            self.port = int(data[1])
        else:
            self.server = server
            self.port = 25
        self.username = username
        self.password = password
        self.connect()

    def connect(self):
        self.connection = smtplib.SMTP(self.server, self.port)
        self.connection.ehlo()
        self.connection.starttls()
        self.connection.ehlo()
        self.connection.login(self.username, self.password)

    def send(self, email_obj):
        from_ = email_obj.email['From']   # if param is Email class obj, always run to here 
        print("from email address : ", from_)  
        if 'Cc' not in email_obj.email : 
            email_obj.email['Cc'] = ''
        to_emails = email_obj.email['To'].split(',') + email_obj.email['Cc'].split(',')  # function equals a_list.append(b_list) 
        print("email To : ", email_obj.email['To'].split(','))
        print("email Cc : ", email_obj.email['Cc'].split(','))
        print("to mail address combine : ", to_emails)
        to = [x_mail for x_mail in to_emails]
        message = str(email_obj)

        return self.connection.sendmail(from_, to, message)

    def close(self):
        self.connection.close()

if __name__ == "__main__" : 

    parser = argparse.ArgumentParser( 
                description="send email with custome parameters", 
                prog="email sender", 
                formatter_class=argparse.ArgumentDefaultsHelpFormatter 
            ) 
    parser.add_argument("-fn", "--sender_name", dest="arg_from_name", help="set sender user name", default="wangyulong") 
    parser.add_argument("-fa", "--from_mail_address", dest="arg_from_mail_addr", help="set sender mail address, must and just one", required=True) 
    parser.add_argument("-fp", "--from_mail_password", dest="arg_from_mail_pwd", help="set sender mail password", required=True) 
    parser.add_argument("-sn", "--mail_server", dest="arg_mail_server", help="set mail service server name", default="mail.xiaomi.com") 
    parser.add_argument("-sp", "--mail_server_port", dest="arg_mail_server_port", type=int, help="set mail service server port", default=25) 
    parser.add_argument("-rn", "--reciver_name", dest="arg_to_name", help="set reciver user name", default="wangyulong") 
    parser.add_argument("-ta", "--to_mail_address", dest="arg_to_mail_addr", help="set reciver mail address, can separated by comma", required=True)
    parser.add_argument("-tc", "--to_mail_cc_address", dest="arg_cc_mail_addr", help="set mail carbon copy address, can separated by comma", default="") 
    parser.add_argument("-ms", "--email_subject", dest="arg_mail_subject", help="set email subject", default="None") 
    parser.add_argument("-mc", "--email_content", dest="arg_mail_content", help="set email content", default="None") 
    parser.add_argument("-x", "--attachements", dest="arg_atach_files", nargs="+", help="set email attachements file path, separated by semicolon, please use absolute file path !") 
    args = parser.parse_args() 

    if args.arg_from_name is not None : 
        from_name = args.arg_from_name 
    if args.arg_mail_server is not None : 
        mail_server = args.arg_mail_server 
    from_mail_addr = args.arg_from_mail_addr 
    from_mail_pwd = args.arg_from_mail_pwd 
    if args.arg_mail_server_port is not None : 
        server_port = args.arg_mail_server_port 
    if args.arg_to_name is not None : 
        to_name = args.arg_to_name 
    to_mail_addr = args.arg_to_mail_addr 
    if args.arg_cc_mail_addr is not None : 
        cc_email = args.arg_cc_mail_addr 
    if args.arg_mail_subject is not None : 
        mail_subject = args.arg_mail_subject 
    if args.arg_mail_content is not None : 
        mail_content = args.arg_mail_content 
    attachments = []
    if args.arg_atach_files is not None :   # nargs can set multi params
        for x in args.arg_atach_files : 
            attachments.append(x) 
    
    print("files combine result : ", attachments) 

    print('Connecting to server...')
    server = EmailConnection(server=mail_server, username=from_mail_addr, password=from_mail_pwd)
    print('Preparing the email...')
    email = Email(from_='%s:<%s>' % (from_name, from_mail_addr), to='%s:<%s>' % (to_name, to_mail_addr),
                cc=cc_email, subject=mail_subject, message=mail_content, attachments=attachments )
    print('Sending...')
    server.send(email_obj=email)
    print('Disconnecting...')
    server.close()
    print('Done!')















