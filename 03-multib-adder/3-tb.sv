module tb;
        logic a, b;
        logic res_or_pirs, res_and_pirs, res_impl_pirs;

        const logic [3:0] AParams = 4'b1100;
        const logic [3:0] BParams = 4'b1010;

        const logic [3:0] and_p_Exp = 4'b1000;
        const logic [3:0] or_p_Exp = 4'b1110;
        const logic [3:0] impl_p_Exp = 4'b1011;

        or_pirs   or_p (.a(a), .b(b), .out(res_or_pirs));
        and_pirs  and_p (.a(a), .b(b), .out(res_and_pirs));
        impl_pirs impl_p (.a(a), .b(b), .out(res_impl_pirs));

        initial begin
                for (int i = 0; i < 4; i++) begin
                        a = AParams[i];
                        b = BParams[i];

                        #10;

                        assert (res_or_pirs === or_p_Exp[i]) 
                                else $error("Or-p failed at A=%b, B=%b", a, b);

                        assert (res_and_pirs === and_p_Exp[i]) 
                                else $error("And-p failed at A=%b, B=%b", a, b);

                        assert (res_impl_pirs === impl_p_Exp[i]) 
                                else $error("Impl-p failed at A=%b, B=%b", a, b);
                end
                $display("All tests were run");
        end
endmodule
