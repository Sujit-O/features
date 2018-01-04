function centralMoment = F_Time_Feature_CentralMoment(frame,orders)

centralMoment=zeros(1, orders);
for i=1:orders
  centralMoment(i) = moment(frame,i);  
end

end