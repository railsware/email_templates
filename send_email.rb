require 'net/smtp'

raise "args shoud be email ans pass" if ARGV.length < 2
username, password = ARGV[0], ARGV[1]

message_raw = File.read('build/index.html')

message = <<-END.split("\n").map!(&:strip).join("\n")
Content-Type: multipart/alternative; boundary="Apple-Mail=_CF186DE0-9DA3-4AD6-9D1B-7D9499A8A1D0"
Date: Sat, 21 Jun 2014 19:07:24 +0300
Message-Id: <0BF9EE79-6259-4AFA-890F-63CF2ACA6#{Random.rand(11000)}@gmail.com>
From: Ira <i.v@rw.rw>
To: Ira <i.v@rw.rw>
Subject: Mailtrap #{Random.rand(11000)} for testing #{Random.rand(11000)}
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
X-Mailer: Apple Mail (2.1878.2)


--Apple-Mail=_CF186DE0-9DA3-4AD6-9D1B-7D9499A8A1D0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;

Some text


--Apple-Mail=_CF186DE0-9DA3-4AD6-9D1B-7D9499A8A1D0
Content-Transfer-Encoding: 7bit
Content-Type: text/html;

#{message_raw}

--Apple-Mail=_CF186DE0-9DA3-4AD6-9D1B-7D9499A8A1D0--
END


Net::SMTP.start('mailtrap.io',
                2525,
                'mailtrap.io',
                username, password, :cram_md5) do |smtp|
    smtp.send_message message, "i.v@rw.rw", ['i.v@rw.rw']
    puts "Email sent"
end