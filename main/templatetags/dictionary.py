from django import template


register = template.Library()


@register.filter
def getDictItemFromKey(dictionary, key):
    return dictionary[key]