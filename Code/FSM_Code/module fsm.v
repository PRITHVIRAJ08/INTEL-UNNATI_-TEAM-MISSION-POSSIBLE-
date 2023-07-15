module fsm(
  input clk,
  input reset,
  input start_payment,
  input [3:0] barcode,
  input [3:0] choice,
  input cheque_inserted,
  input [7:0] cheque_amount,
  input dd_inserted,
  input [7:0] dd_amount,
  input card_inserted,
  input [15:0] card_number,
  input [3:0] card_choice, // 0: Debit card, 1: Credit card
  input [7:0] card_amount,
  input currency_inserted,
  input [7:0] currency_amount,
  output reg [7:0] remaining_amount,
  output reg payment_complete,
  output reg line_disconnected
);

  // Internal signals
  reg [3:0] state;
  reg [7:0] payment_amount;
  reg [7:0] total_amount;
  reg cheque_inserted_prev;
  reg dd_inserted_prev;
  reg card_inserted_prev;
  reg currency_inserted_prev;

  // Constants for note denominations
  localparam DENOM_1000 = 4'b1000;
  localparam DENOM_500 = 4'b0100;
  localparam DENOM_100 = 4'b0010;
  localparam DENOM_50 = 4'b0001;
  localparam DENOM_20 = 4'b1010;
  localparam DENOM_10 = 4'b0110;
  localparam DENOM_5 = 4'b0000;

  // State definitions
  localparam IDLE = 4'b0000;
  localparam PLACE_BARCODE = 4'b0001;
  localparam MOVE_BILL = 4'b0010;
  localparam MAKE_CHOICE = 4'b0011;
  localparam INSERT_CHEQUE = 4'b0100;
  localparam ENTER_CHEQUE_AMOUNT = 4'b0101;
  localparam VERIFY_CHEQUE = 4'b0110;
  localparam INSERT_DD = 4'b0111;
  localparam ENTER_DD_AMOUNT = 4'b1000;
  localparam VERIFY_DD = 4'b1001;
  localparam INSERT_CARD = 4'b1010;
  localparam ENTER_CARD_AMOUNT = 4'b1011;
  localparam VERIFY_CARD = 4'b1100;
  localparam INSERT_CURRENCY = 4'b1101;
  localparam CHECK_AMOUNT = 4'b1110;

  // Next state and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      remaining_amount <= 0;
      payment_complete <= 0;
      line_disconnected <= 0;
      cheque_inserted_prev <= 0;
      dd_inserted_prev <= 0;
      card_inserted_prev <= 0;
      currency_inserted_prev <= 0;
    end else begin
      case (state)
        IDLE:
          if (start_payment) begin
            state <= PLACE_BARCODE;
          end
        PLACE_BARCODE:
          begin
            state <= MOVE_BILL;
          end
        MOVE_BILL:
          begin
            state <= MAKE_CHOICE;
          end
        MAKE_CHOICE:
          begin
            if (choice == 1) begin
              state <= INSERT_CHEQUE;
            end else if (choice == 2) begin
              state <= INSERT_DD;
            end else if (choice == 3) begin
              state <= INSERT_CARD;
            end else if (choice == 4) begin
              state <= INSERT_CURRENCY;
            end else if (choice == 0) begin
              state <= CHECK_AMOUNT;
            end
          end
        INSERT_CHEQUE:
          begin
            if (cheque_inserted && !cheque_inserted_prev) begin
              state <= ENTER_CHEQUE_AMOUNT;
              payment_amount <= cheque_amount;
              total_amount <= cheque_amount;
              remaining_amount <= cheque_amount;
              payment_complete <= 0;
              line_disconnected <= 0;
            end
          end
        ENTER_CHEQUE_AMOUNT:
          begin
            state <= VERIFY_CHEQUE;
          end
        VERIFY_CHEQUE:
          begin
            if (payment_amount == total_amount) begin
              state <= IDLE;
              payment_amount <= 0;
              remaining_amount <= 0;
              payment_complete <= 1;
              line_disconnected <= 0;
            end else if (payment_amount < total_amount) begin
              state <= INSERT_CURRENCY;
              remaining_amount <= total_amount - payment_amount;
            end
          end
        INSERT_DD:
          begin
            if (dd_inserted && !dd_inserted_prev) begin
              state <= ENTER_DD_AMOUNT;
              payment_amount <= dd_amount;
              total_amount <= dd_amount;
              remaining_amount <= dd_amount;
              payment_complete <= 0;
              line_disconnected <= 0;
            end
          end
        ENTER_DD_AMOUNT:
          begin
            state <= VERIFY_DD;
          end
        VERIFY_DD:
          begin
            if (payment_amount == total_amount) begin
              state <= IDLE;
              payment_amount <= 0;
              remaining_amount <= 0;
              payment_complete <= 1;
              line_disconnected <= 0;
            end else if (payment_amount < total_amount) begin
              state <= INSERT_CURRENCY;
              remaining_amount <= total_amount - payment_amount;
            end
          end
        INSERT_CARD:
          begin
            if (card_inserted && !card_inserted_prev) begin
              state <= ENTER_CARD_AMOUNT;
              if (card_choice == 0) begin
                payment_amount <= card_amount;
                total_amount <= card_amount;
                remaining_amount <= card_amount;
              end else if (card_choice == 1) begin
                payment_amount <= card_amount;
                total_amount <= card_amount;
                remaining_amount <= card_amount;
              end
              payment_complete <= 0;
              line_disconnected <= 0;
            end
          end
        ENTER_CARD_AMOUNT:
          begin
            state <= VERIFY_CARD;
          end
        VERIFY_CARD:
          begin
            if (payment_amount == total_amount) begin
              state <= IDLE;
              payment_amount <= 0;
              remaining_amount <= 0;
              payment_complete <= 1;
              line_disconnected <= 0;
            end else if (payment_amount < total_amount) begin
              state <= INSERT_CURRENCY;
              remaining_amount <= total_amount - payment_amount;
            end
          end
        INSERT_CURRENCY:
          begin
            if (currency_inserted && !currency_inserted_prev) begin
              state <= CHECK_AMOUNT;
              payment_amount <= currency_amount;
              total_amount <= currency_amount;
              remaining_amount <= currency_amount;
              payment_complete <= 0;
              line_disconnected <= 0;
            end
          end
        CHECK_AMOUNT:
          begin
            if (start_payment) begin
              state <= IDLE;
              remaining_amount <= 0;
              payment_complete <= 0;
              line_disconnected <= 0;
            end
          end
      endcase
    end
    cheque_inserted_prev <= cheque_inserted;
    dd_inserted_prev <= dd_inserted;
    card_inserted_prev <= card_inserted;
    currency_inserted_prev <= currency_inserted;
  end
endmodule