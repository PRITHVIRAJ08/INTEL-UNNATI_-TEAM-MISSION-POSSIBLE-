module atp_tb;

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

  atp dut (
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

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    start_payment = 0;
    barcode = 0;
    choice = 0;
    cheque_inserted = 0;
    cheque_amount = 0;
    dd_inserted = 0;
    dd_amount = 0;
    card_inserted = 0;
    card_number = 0;
    card_choice = 0;
    card_amount = 0;
    currency_inserted = 0;
    currency_amount = 0;

    #10 reset = 0;

    #5 start_payment = 1;
    #5 barcode = 2; 
    #10 start_payment = 0;
    #100;

    #5 start_payment = 1;
    #5 barcode = 3; // Example barcode value
    #10 start_payment = 0;
    #5 choice = 1;
    #5 cheque_inserted = 1;
    #5 cheque_amount = 50; // Example cheque amount
    #10 cheque_inserted = 0;
    #100;

    // Test case 3
    #5 start_payment = 1;
    #5 barcode = 4; 
    #10 start_payment = 0;
    #5 choice = 3;
    #5 card_inserted = 1;
    #5 card_number = 1234; 
    #5 card_choice = 0; // Debit card
    #5 card_amount = 100; // Example card amount
    #10 card_inserted = 0;
    #100;

    // Test case 4
    #5 start_payment = 1;
    #5 barcode = 5; 
    #10 start_payment = 0;
    #5 choice = 4;
    #5 currency_inserted = 1;
    #5 currency_amount = 20;
    #10 currency_inserted = 0;
    #100;

    #5 start_payment = 1;
    #5 barcode = 6; // Example barcode value
    #10 start_payment = 0;
    #5 choice = 0;
    #10 start_payment = 1; 
    #10 start_payment = 0;
    #100;

    #10 $finish;
  end
endmodule