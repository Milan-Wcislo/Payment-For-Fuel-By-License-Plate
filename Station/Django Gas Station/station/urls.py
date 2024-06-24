from django.contrib import admin
from django.urls import include, path
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("products.urls")),
    path('api/products/', include('products.api.urls')),
    path("accounts/", include("customers.urls")),
    path("api/customers/", include("customers.api.urls")),
    path("gas_station/", include("gas_station.urls")),
    path("api/gas_station/", include("gas_station.api.urls")),
]  + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)