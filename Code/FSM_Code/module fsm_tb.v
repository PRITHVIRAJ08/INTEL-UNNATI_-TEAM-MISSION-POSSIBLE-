module fsm_tb;

  reg clk;
  reg reset;
  reg start_payment;
  reg [3:0] barcode;
  reg [3:0] choice;
  reg cheque_inserted;
  reg [7:0] cheque_amount;
  reg dd_inserted;
  reg [7:0] dd_amount;
  reg card_inserted;
  reg [15:0] card_number;
  reg [3:0] card_choice;
  reg [7:0] card_amount;
  reg currency_inserted;
  reg [7:0] currency_amount;

  wire [7:0] remaining_amount;
  wire payment_complete;
  wire line_disconnected;

  fsm dut (
    .clk(clk),
    .reset(reset),
    .start_payment(start_payment),
    .barcode(barcode),
    .choice(choice),
    .cheque_inserted(cheque_inserted),
    .cheque_amount(cheque_amount),
    .dd_inserted(dd_inserted),
    .dd_amount(dd_amount),
    .card_inserted(card_inserted),
    .card_number(card_number),
    .card_choice(card_choice),
    .card_amount(card_amount),
    .currency_inserted(currency_inserted),
    .currency_amount(currency_amount),
    .remaining_amount(remaining_amount),
    .payment_complete(payment_complete),
    .line_disconnected(line_disconnected)
  );

  always begin
    clk = 0;
    #5;
    clk = 1;
    #5;
  end

  initial begin
    reset = 1;
    #10;
    reset = 0;
    #10;
    start_payment = 1;
    #5;
    start_payment = 0;
    #5;
    barcode = 4'b0101;
    #5;
    #5;
    choice = 4'b0001;
    #5;
    cheque_inserted = 1;
    cheque_amount = 8'h32;
    #5;
    #5;
    #5;
    #50;
    start_payment = 1;
    #5;
    start_payment = 0;
    #5;
    barcode = 4'b0011;
    #5;
    #5;
    choice = 4'b0010;
    #5;
    dd_inserted = 1;
    dd_amount = 8'h50;
    #5;
    #5;
    #5;
    #50;
    start_payment = 1;
    #5;
    start_payment = 0;
    #5;
    barcode = 4'b0110;
    #5;
    #5;
    choice = 4'b0011;
    #5;
    card_inserted = 1;
    card_choice = 4'b0000;
    card_amount = 8'h70;
    #5;
    #5;
    #5;
    #50;
    start_payment = 1;
    #5;
    start_payment = 0;
    #5;
    barcode = 4'b1010;
    #5;
    #5;
    choice = 4'b0100;
    #5;
    currency_inserted = 1;
    currency_amount = 8'h20;
    #5;
    #50;
    start_payment = 1;
    #5;
    start_payment = 0;
    #5;
    barcode = 4'b0000;
    #5;
    #5;
    choice = 4'b0000;
    #5;
    #50;
    $finish;
  end

endmodule
