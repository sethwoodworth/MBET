from django.shortcuts import get_object_or_404, render_to_response
from django.contrib.auth.models import User
from django.core import serializers

from mbet.curate.models import *

from xml.dom.minidom import Document

def default(request):
    pass


def gen_xml(request):
    #vids = Video.objects.filter(collection=1).all()
    vids = ['1', 'a']
    
    doc = Document()
    channel = doc.createElement('channel')
    doc.appendChild(channel)

    for video in vids:
        item = doc.createElement('item')
        channel.appendChild(item)

        title = doc.createElement('title')
        item.appendChild(title)
        title_value = doc.createTextNode("This is the title")
        title.appendChild(title_value)


        link = doc.createElement('link')
        item.appendChild(link)
        link_url = doc.createTextNode("http://km.support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1211/sample_iTunes.mov")
        link.appendChild(link_url)

        thumb = doc.createElement('thumbnail')
        item.appendChild(thumb)
        thumb_url = doc.createTextNode("http://a.images.blip.tv/Commonscreative-CCOfficeLunchNLearnSimoneAliprandi614-577-504.jpg")
        thumb.appendChild(thumb_url)

    xml =  doc.toprettyxml()
    return render_to_response('xmlRender.xml', {'xml': xml})
