# .devcontainer/setup-sshd.sh
#!/bin/bash
set -e

# ضبط اللغة الافتراضية لتجنب تحذيرات locale
if [ -f /etc/locale.gen ]; then
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen || true
  locale-gen || true
fi

# إنشاء مستخدم root كلمة المرور وتكوين sshd
# تعيين كلمة مرور root إلى 1212
echo "root:1212" | chpasswd

# تأكد من وجود ملف إعدادات sshd
if [ ! -f /etc/ssh/sshd_config ]; then
  mkdir -p /etc/ssh
  ssh-keygen -A
fi

# تعديل إعدادات sshd للسماح بدخول root وكلمات المرور
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config || echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config || echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# تأكد من أن المنفذ الافتراضي 22 مضبوط
sed -i 's/^#\?Port.*/Port 22/' /etc/ssh/sshd_config || echo "Port 22" >> /etc/ssh/sshd_config

# إنشاء مفاتيح SSH إن لم تكن موجودة
ssh-keygen -A || true

# تأكد من صلاحيات المجلدات
chmod 755 /var/run/sshd || true

# لا نبدأ sshd هنا لأننا سنستخدم supervisor لبدء الخدمة تلقائياً
exit 0
