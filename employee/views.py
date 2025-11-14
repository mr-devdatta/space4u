from django.http import HttpResponse
from django.views import View

class EmployeeView(View):
    
    def get(self,request):
        return self.test(request) 
        

    def test(self, request):
        return HttpResponse("<h2>Tdddhis is dddddd timeddddd to fly......sedfdsfsdf.....gtgtg</h2>")


