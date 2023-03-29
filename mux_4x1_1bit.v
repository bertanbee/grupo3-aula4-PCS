module mux_4x1_1bit (
    input I0, I1, I2, I3,
    input A0, A1,
    output Q
);
    wire T1, T2, T3, T4, A0not, A1not;

    and U1 (T1, I0, A0not, A1not);
    and U2 (T2, I1, A0not, A1);
    and U3 (T3, I2, A0, A1not);
    and U4 (T4, I3, A0, A1);
    not U5 (A0not, A0);
    not U6 (A1not, A1);
    or U7 (Q, T1, T2, T3, T4);

endmodule