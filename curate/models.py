from django.db import models
from django.contrib.auth.models import User


class Org(models.Model):
    """
    """
    title = models.CharField(max_length=100)
    description = models.TextField()

    safe_name = models.CharField(max_length=40)

    url = models.URLField()

    def __unicode__(self):
        return self.title



class Collection(models.Model):
    """
    """
    title = models.CharField(max_length=100)
    description = models.TextField()

    organization = models.ForeignKey(Org) # may restrict?
    user = models.ForeignKey(User) # store for the heck of it

    created = models.DateField()
    last_updated = models.DateField()

    def __unicode__(self):
        return self.title + ' ' + str(self.last_updated)


class Video(models.Model):
    """
    Info about and from the video object, to be serialized to device on request.
    """
    title = models.CharField(max_length=100)
    description = models.TextField()

    organization = models.ForeignKey(Org)
    collection = models.ForeignKey(Collection)
    user = models.ForeignKey(User)

    url = models.URLField()
    thumbnail = models.URLField()

    is_published = models.BooleanField(default=True)

    created = models.DateField()
    last_updated = models.DateField()

    def __unicode__(self):
        return self.title

