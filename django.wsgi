import os                                                                                                
import sys


sys.path.append('/var/www/')
sys.path.append('/var/www/mbet')


os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
