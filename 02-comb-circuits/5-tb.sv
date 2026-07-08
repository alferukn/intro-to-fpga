module tb;

        logic a, b;
        logic res_impl, res_nimpl, res_pirs, res_schaef;

        const logic [3:0] AParams = 4'b0011;
        const logic [3:0] BParams = 4'b0101;

        const logic [3:0] implExp = 4'b1101;
        const logic [3:0] nimplExp = 4'b0010;
        const logic [3:0] pirsExp = 4'b1000;
        const logic [3:0] schaefExp = 4'b1110;

        implic impl (.a(a), .b(b), .c(res_impl));
        not_implic nimpl (.a(a), .b(b), .c(res_nimpl));
        pirs p (.a(a), .b(b), .c(res_pirs));
        schaeffer add (.a(a), .b(b), .c(res_schaef));

        initial begin
                for (int i = 0; i < 4; i++) begin
                        a = AParams[i];
                        b = BParams[i];

                        #10;

                        assert (res_impl === implExp[i]) 
                                else $error("Impl failed at A=%b, B=%b", a, b);

                        assert (res_nimpl === nimplExp[i]) 
                                else $error("N-impl failed at A=%b, B=%b", a, b);

                        assert (res_pirs === pirsExp[i]) 
                                else $error("Pirs failed at A=%b, B=%b", a, b);

                        assert (res_schaef === schaefExp[i]) 
                                else $error("Schaeffer failed at A=%b, B=%b", a, b);

                end
                $display("All tests were run");
        end
endmodule