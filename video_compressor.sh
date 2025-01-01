#!/bin/bash

# التحقق من نظام التشغيل
OS=$(uname -s)

install_ffmpeg() {
    echo "FFmpeg غير مثبت. سيتم تثبيته الآن..."
    if [[ "$OS" == "Darwin" ]]; then
        # macOS
        if ! command -v brew &> /dev/null; then
            echo "Homebrew غير مثبت. سيتم تثبيته الآن..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        echo "تثبيت FFmpeg باستخدام Homebrew..."
        brew install ffmpeg
    elif [[ "$OS" == "Linux" ]]; then
        # Linux
        if command -v apt &> /dev/null; then
            echo "تثبيت FFmpeg باستخدام apt..."
            sudo apt update
            sudo apt install -y ffmpeg
        elif command -v yum &> /dev/null; then
            echo "تثبيت FFmpeg باستخدام yum..."
            sudo yum install -y ffmpeg
        elif command -v pacman &> /dev/null; then
            echo "تثبيت FFmpeg باستخدام pacman..."
            sudo pacman -S --noconfirm ffmpeg
        else
            echo "تعذر العثور على مدير الحزم المناسب. يرجى تثبيت FFmpeg يدويًا."
            exit 1
        fi
    else
        echo "نظام التشغيل غير مدعوم. يرجى تثبيت FFmpeg يدويًا."
        exit 1
    fi
}

# التحقق من وجود FFmpeg
if ! command -v ffmpeg &> /dev/null; then
    install_ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        echo "فشل تثبيت FFmpeg. يرجى التحقق يدويًا."
        exit 1
    fi
fi

echo "FFmpeg مثبت. جاهز للعمل!"

# طلب الفيديو المطلوب ضغطه
read -p "أدخل مسار ملف الفيديو: " input_file

# التحقق من وجود الملف
if [ ! -f "$input_file" ]; then
    echo "الملف $input_file غير موجود. تحقق من المسار وحاول مرة أخرى."
    exit 1
fi

# اختيار الجودة
echo "اختر الجودة المطلوبة:"
echo "1) 480p"
echo "2) 720p"
echo "3) 1080p"
echo "4) تخصيص نسبة ضغط"

read -p "أدخل اختيارك (1/2/3/4): " choice

# ضبط إعدادات الجودة
case $choice in
    1)
        resolution="640x480"
        ;;
    2)
        resolution="1280x720"
        ;;
    3)
        resolution="1920x1080"
        ;;
    4)
        read -p "أدخل نسبة الضغط (مثال: 50 لـ 50% من الحجم): " compression
        if [[ "$compression" =~ ^[0-9]+$ ]] && [ "$compression" -gt 0 ] && [ "$compression" -lt 100 ]; then
            bitrate=$(ffmpeg -i "$input_file" 2>&1 | grep -oP '(?<=bitrate: )\\d+' | head -1)
            target_bitrate=$((bitrate * compression / 100))
        else
            echo "إدخال غير صحيح. يرجى إدخال رقم بين 1 و 99."
            exit 1
        fi
        ;;
    *)
        echo "اختيار غير صحيح. يرجى المحاولة مرة أخرى."
        exit 1
        ;;
esac

# إنشاء اسم ملف الإخراج
output_file="${input_file%.*}_compressed.mp4"

# تنفيذ ضغط الفيديو
if [ "$choice" -eq 4 ]; then
    echo "جارٍ ضغط الفيديو بنسبة $compression%..."
    ffmpeg -i "$input_file" -b:v "${target_bitrate}k" -bufsize "${target_bitrate}k" -y "$output_file"
else
    echo "جارٍ ضغط الفيديو بدقة $resolution..."
    ffmpeg -i "$input_file" -vf scale=$resolution -c:a copy -y "$output_file"
fi

# التحقق من نجاح العملية
if [ $? -eq 0 ]; then
    echo "تم ضغط الفيديو بنجاح! الملف الجديد: $output_file"
else
    echo "حدث خطأ أثناء ضغط الفيديو."
    exit 1
fi
