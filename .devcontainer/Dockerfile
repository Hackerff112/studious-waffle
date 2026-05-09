# .devcontainer/Dockerfile
FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

# تحديث النظام وتثبيت الحزم المطلوبة
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openssh-server \
      supervisor \
      git \
      curl \
      wget \
      python3 \
      python3-pip \
      nodejs \
      npm \
      ca-certificates \
      locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# إنشاء مجلدات مطلوبة لـ sshd و supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor

# نسخ ملفات الإعداد إلى الصورة
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY setup-sshd.sh /usr/local/bin/setup-sshd.sh
RUN chmod +x /usr/local/bin/setup-sshd.sh

# ضبط كلمة مرور root وتكوين SSH عند بناء الصورة
# ملاحظة: يمكن إعادة تعيين كلمة المرور لاحقاً إذا رغبت
RUN /usr/local/bin/setup-sshd.sh

# تعريض المنفذ 22
EXPOSE 22

# تشغيل supervisor كعملية PID 1 لتشغيل sshd تلقائياً
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
