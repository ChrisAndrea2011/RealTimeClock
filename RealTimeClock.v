module RealTimeClock(
  input CLK1Hz,
  input CLK500Hz,
  input RST,
  output reg [6:0]SevenSeg);
  reg [3:0]countsec1;
  reg [3:0]countsec2;
  reg [3:0]countmin1;
  reg [3:0]countmin2;
  reg [3:0]counthour1;
  reg [3:0]counthour2;
 // reg count1Hz;
 // reg count500Hz;
  reg [3:0]Bin;
  reg [7:0]AN;
  reg [2:0]count_anode;
 // reg resetcounters;
  //Assume system clock is 100Mhz. Generate the 1Hz clock from this. 
  //The 1Hz clock will give you a clock period of 1s.
  
 always @(posedge CLK1Hz)
      begin
        if (RST == 1)begin
          countsec1 =  4'b0000;
          countsec2 = 4'b0000;
          countmin1 = 4'b0000;
          countmin2 = 4'b0000;
          counthour1 =  4'b0000;
          counthour2 =  4'b0000;
          count_anode = 3'b000;end
          
end
      always @(posedge CLK1Hz)
      begin  
        countsec1 = countsec1 +4'b0001;
        if (countsec1 == 4'b1010 )begin      
          countsec2 = countsec2 + 4'b0001;
          countsec1 =  4'b0000;
         //   if( countsec1 == 4'b1010 && countsec2 == 4'b0101) begin
         if(countsec2 == 4'b0110) begin
              countmin1 = countmin1 + 4'b0001;
             countsec2 = 4'b0000; 
                  if (countmin1 == 4'b1010) begin
                    countmin2 = countmin2 + 4'b0001;
                    countmin1 = 4'b0000;
              //    if (countmin2 == 4'b0101 && countmin1 == 4'b1001) begin
              if (countmin2 == 4'b0110 ) begin
                  counthour1 = counthour1 + 4'b0001;
                  countmin2 = 4'b0000;end
              	     if (counthour1 == 4'b1010 ) begin
                      counthour2 = counthour2 + 4'b0001;
                      counthour1 =  4'b0000;end
                      if (counthour2 == 4'b0010 && counthour1 ==4'b0100) begin
          counthour2 = 4'b0000;
          counthour1 =  4'b0000;
          countmin2 = 4'b0000;
          countmin1 = 4'b0000;
          countsec2 = 4'b0000;
          countsec1 =  4'b0000;
        end
      end          
   end
 end           
         
            end  
  
        always @(posedge CLK500Hz) begin
          count_anode = count_anode + 3'b001;
          if (count_anode == 3'b001) begin
            AN = 11111011;
            Bin = countsec1; end 
         else if(count_anode == 3'b010)begin
            AN = 11110111;
            Bin = countsec2;end
         else if(count_anode == 3'b010)begin
            AN = 11101111;
            Bin = countmin1; end
         else if(count_anode == 3'b100)begin
            AN = 11011111;
            Bin = countmin2; end
         else if(count_anode == 3'b101)begin
            AN = 10111111;
            Bin = counthour1; end
         else if(count_anode == 3'b110)begin
            AN = 01111111;
            Bin = counthour2;
            count_anode = 3'b000;end 
        end
          always @(Bin) begin
            case(Bin)
              4'b0000: SevenSeg = 7'b0000001;
              4'b0001: SevenSeg = 7'b1001111;
              4'b0010: SevenSeg = 7'b0010010;
              4'b0011: SevenSeg = 7'b0000110;
              4'b0100: SevenSeg = 7'b1001100;
              4'b0101: SevenSeg = 7'b0100100;
              4'b0110: SevenSeg = 7'b0100000;
              4'b0111: SevenSeg = 7'b0001111;
              4'b1000: SevenSeg = 7'b0000000;
              4'b1001: SevenSeg = 7'b0000100;
              default: SevenSeg = 7'b1111111;
            endcase
          end
        endmodule
            
          
  //Assuming that the seven segment display is Common Anode,
  //and for a refresh rate of 50Hz, ( a period of 0.02s)
  
          
module RealTimeClock_TB();
    reg  CLK1Hz;
    reg CLK500Hz;
    reg  RST;
    wire [6:0]SevenSeg;
    
RealTimeClock RealTimeClock_inst(.CLK1Hz(CLK1Hz),.CLK500Hz(CLK500Hz), .RST(RST), .SevenSeg(SevenSeg));

initial
begin
  CLK1Hz = 0;
forever #35 CLK1Hz = ~CLK1Hz;
  end
  
  initial 
  begin
    CLK500Hz=0;
    forever #5 CLK500Hz = ~CLK500Hz;
  end
  
  initial
  begin 
  RST =1; #40;
  RST = 0; #200;
end
endmodule 
      
          