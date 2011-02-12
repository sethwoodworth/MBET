from django.conf.urls.defaults import *
from mbet.curate.models import *

urlpatterns = patterns('',
    (r'^$', 'mbet.curate.views.default'),
    (r'^xml$', 'mbet.curate.views.gen_xml'),
)
