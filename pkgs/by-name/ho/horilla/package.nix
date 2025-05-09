{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "horilla";
  version = "1.2.3";
  format = "other";

  src = fetchFromGitHub {
    owner = "horilla-opensource";
    repo = "horilla";
    tag = version;
    hash = "sha256-LY4fu+MYOkoV+oaHV9tYGJVk8EW4Qs3Div1+AmSIKMo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    APScheduler
    arabic-reshaper
    asgiref
    asn1crypto
    beautifulsoup4
    certifi
    cffi
    chardet
    charset-normalizer
    click
    cryptography
    cssselect2
    django
    django-auditlog
    (django-apscheduler.override { django_5 = django; }) # Pypi states that django-apscheduler is compatible with Django4.2
    django-cors-headers
    django-environ
    django-filter
    django-haystack
    django-import-export
    jsonfield # django-jsonfield
    django-mathfilters
    django-model-utils
    django-simple-history
    django-widget-tweaks
    djangorestframework
    djangorestframework-simplejwt
    drf-yasg
    et-xmlfile
    html5lib
    jinja2
    idna
    lxml
    numpy
    openpyxl
    oscrypto
    pandas
    pdfkit
    pillow
    pycparser
    pyhanko
    pyhanko-certvalidator
    pymupdf
    pypdf
    pypng
    python-bidi
    python-dateutil
    pytz
    pyyaml
    pyzk
    qrcode
    reportlab
    requests
    responses
    setuptools
    six
    sqlparse
    svglib
    swapper
    tinycss2
    typing-extensions
    tzdata
    tzlocal
    uritools
    urllib3
    utils
    webencodings
    whoosh
    xhtml2pdf
    XlsxWriter
    gunicorn
    psycopg2-binary
    whitenoise

    # for manage.py
    distutils
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/horilla
    cp -r ./ $out/opt/horilla

    makeWrapper $out/opt/horilla/manage.py $out/bin/horilla \
      --prefix PYTHONPATH : "$PYTHONPATH"

    runHook postInstall
  '';

  meta = {
    description = "Free and open source HR software";
    homepage = "https://github.com/horilla-opensource/horilla";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bengsparks ];
    mainProgram = "horilla";
  };
}
