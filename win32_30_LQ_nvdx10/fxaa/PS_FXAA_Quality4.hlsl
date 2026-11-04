sampler2D BackBufferSampler : register(s0);
float4 globalScreenSize : register(c41);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	r0 = float4(1, 1, 0, 0) * texcoord.xyxx;
	r0 = tex2Dlod(BackBufferSampler, r0);
	r1.xyz = float3(1, 0, -1);
	r2.xyz = globalScreenSize.wzw * r1.xxy + texcoord.yxy;
	r3.xzw = float3(1, 0, 0) * texcoord.xxx;
	r3.y = r2.x;
	r3 = tex2Dlod(BackBufferSampler, r3);
	r2 = r2.yzyy * float4(1, 1, 0, 0);
	r2 = tex2Dlod(BackBufferSampler, r2);
	r2.xyz = globalScreenSize.wzw * r1.zzy + texcoord.yxy;
	r4.xzw = float3(1, 0, 0) * texcoord.xxx;
	r4.y = r2.x;
	r4 = tex2Dlod(BackBufferSampler, r4);
	r5 = r2.yzyy * float4(1, 1, 0, 0);
	r5 = tex2Dlod(BackBufferSampler, r5);
	r1.y = max(r3.w, r0.w);
	r1.w = min(r0.w, r3.w);
	r3.x = max(r2.w, r1.y);
	r3.y = min(r1.w, r2.w);
	r1.y = max(r4.w, r5.w);
	r1.w = min(r5.w, r4.w);
	r2.x = max(r1.y, r3.x);
	r2.y = min(r3.y, r1.w);
	r1.y = r2.x * 0.166;
	r1.w = -r2.y + r2.x;
	r2.x = min(-r1.y, -0.0833);
	if (r1.w < -r2.x) {
		o.xyz = saturate(r0.xyz);
	} else {
		r6.xy = -globalScreenSize.zw + texcoord.xy;
		r6.zw = 0;
		r6 = tex2Dlod(BackBufferSampler, r6);
		r7.xy = globalScreenSize.zw + texcoord.xy;
		r7.zw = 0;
		r7 = tex2Dlod(BackBufferSampler, r7);
		r8 = globalScreenSize.zwzw * r1.xzzx + texcoord.xyxy;
		r9 = r8.xyxx * float4(1, 1, 0, 0);
		r9 = tex2Dlod(BackBufferSampler, r9);
		r8 = r8.zwxx * float4(1, 1, 0, 0);
		r8 = tex2Dlod(BackBufferSampler, r8);
		r1.x = r3.w + r4.w;
		r1.y = r2.w + r5.w;
		r1.z = 1 / r1.w;
		r1.w = r1.y + r1.x;
		r1.x = r0.w * -2 + r1.x;
		r1.y = r0.w * -2 + r1.y;
		r2.x = r7.w + r9.w;
		r2.y = r6.w + r9.w;
		r2.z = r2.w * -2 + r2.x;
		r2.y = r4.w * -2 + r2.y;
		r3.x = r6.w + r8.w;
		r3.y = r7.w + r8.w;
		r1.x = abs(r1.x) * 2 + abs(r2.z);
		r1.y = abs(r1.y) * 2 + abs(r2.y);
		r2.y = r5.w * -2 + r3.x;
		r2.z = r3.w * -2 + r3.y;
		r1.xy = r1.xy + abs(r2.yz);
		r2.x = r2.x + r3.x;
		r1.x = -r1.y + r1.x;
		r1.y = r1.w * 2 + r2.x;
		r1.w = (r1.x >= 0) ? r4.w : r5.w;
		r2.x = (r1.x >= 0) ? r3.w : r2.w;
		r2.y = (r1.x >= 0) ? globalScreenSize.w : globalScreenSize.z;
		r1.y = r1.y * 0.083333336 + -r0.w;
		r2.z = -r0.w + r1.w;
		r2.w = -r0.w + r2.x;
		r1.w = r0.w + r1.w;
		r2.x = r0.w + r2.x;
		r3.x = -abs(r2.w) + abs(r2.z);
		r3.y = max(abs(r2.z), abs(r2.w));
		r2.y = (r3.x >= 0) ? -r2.y : r2.y;
		r1.y = saturate(r1.z * abs(r1.y));
		r2.zw = r2.yy * 0.5 + texcoord.xy;
		r4.x = (r1.x >= 0) ? texcoord.x : r2.z;
		r4.y = (r1.x >= 0) ? r2.w : texcoord.y;
		r1.z = r1.y * -2 + 3;
		r4.zw = 0;
		r5 = tex2Dlod(BackBufferSampler, r4);
		r1.y = r1.y * r1.y;
		r1.w = (r3.x >= 0) ? r1.w : r2.x;
		r2.x = r3.y * 0.25;
		r2.z = r1.w * -0.5 + r0.w;
		r1.y = r1.y * r1.z;
		r3.xz = r1.ww * -0.5 + r5.ww;
		r1.z = r3.y * -0.25 + abs(r3.x);
		if (abs(r3.x) < r2.x) {
			if (abs(r3.x) >= r2.x) {
				r2.w = r3.x;
			} else {
				r2.w = r5.w;
				r3.x = r5.w;
			}
			r3.w = r1.w * -0.5 + r2.w;
			r3.z = (r1.z >= 0) ? r2.w : r3.w;
			r2.w = r1.w * -0.5 + r3.x;
			r3.x = (r1.z >= 0) ? r3.x : r2.w;
			r4.zw = r3.yy * -0.25 + abs(r3.zx);
			r5.xy = (r4.zw >= 0) ? 0 : 1;
			r1.z = r5.y + r5.x;
			if (-r1.z < 0) {
				if (abs(r3.z) >= r2.x) {
				} else {
					r3.z = r5.w;
				}
				if (abs(r3.x) >= r2.x) {
				} else {
					r3.x = r5.w;
				}
				r1.z = r1.w * -0.5 + r3.z;
				r3.z = (r4.z >= 0) ? r3.z : r1.z;
				r1.z = r1.w * -0.5 + r3.x;
				r3.x = (r4.w >= 0) ? r3.x : r1.z;
				r4.zw = r3.yy * -0.25 + abs(r3.zx);
				r5.xy = (r4.zw >= 0) ? 0 : 1;
				r1.z = r5.y + r5.x;
				if (-r1.z < 0) {
					if (abs(r3.z) >= r2.x) {
					} else {
						r3.z = r5.w;
					}
					if (abs(r3.x) >= r2.x) {
					} else {
						r3.x = r5.w;
					}
					r1.z = r1.w * -0.5 + r3.z;
					r3.z = (r4.z >= 0) ? r3.z : r1.z;
					r1.z = r1.w * -0.5 + r3.x;
					r3.x = (r4.w >= 0) ? r3.x : r1.z;
					r4.zw = r3.yy * -0.25 + abs(r3.zx);
					r5.xy = (r4.zw >= 0) ? 0 : 1;
					r1.z = r5.y + r5.x;
					if (-r1.z < 0) {
						if (abs(r3.z) >= r2.x) {
						} else {
							r3.z = r5.w;
						}
						if (abs(r3.x) >= r2.x) {
						} else {
							r3.x = r5.w;
						}
						r1.z = r1.w * -0.5 + r3.z;
						r3.z = (r4.z >= 0) ? r3.z : r1.z;
						r1.z = r1.w * -0.5 + r3.x;
						r3.x = (r4.w >= 0) ? r3.x : r1.z;
						r4.zw = r3.yy * -0.25 + abs(r3.zx);
						r5.xy = (r4.zw >= 0) ? 0 : 1;
						r1.z = r5.y + r5.x;
						if (-r1.z < 0) {
							if (abs(r3.z) >= r2.x) {
							} else {
								r3.z = r5.w;
							}
							if (abs(r3.x) >= r2.x) {
							} else {
								r3.x = r5.w;
							}
							r1.z = r1.w * -0.5 + r3.z;
							r3.z = (r4.z >= 0) ? r3.z : r1.z;
							r1.z = r1.w * -0.5 + r3.x;
							r3.x = (r4.w >= 0) ? r3.x : r1.z;
							r4.zw = r3.yy * -0.25 + abs(r3.zx);
							r5.xy = (r4.zw >= 0) ? 0 : 1;
							r1.z = r5.y + r5.x;
							if (-r1.z < 0) {
								if (abs(r3.z) >= r2.x) {
								} else {
									r3.z = r5.w;
								}
								if (abs(r3.x) >= r2.x) {
								} else {
									r3.x = r5.w;
								}
								r1.z = r1.w * -0.5 + r3.z;
								r3.z = (r4.z >= 0) ? r3.z : r1.z;
								r1.z = r1.w * -0.5 + r3.x;
								r3.x = (r4.w >= 0) ? r3.x : r1.z;
								r4.zw = r3.yy * -0.25 + abs(r3.zx);
								r5.xy = (r4.zw >= 0) ? 0 : 1;
								r1.z = r5.y + r5.x;
								if (-r1.z < 0) {
									if (abs(r3.z) >= r2.x) {
									} else {
										r3.z = r5.w;
									}
									if (abs(r3.x) >= r2.x) {
									} else {
										r3.x = r5.w;
									}
									r1.z = r1.w * -0.5 + r3.z;
									r3.z = (r4.z >= 0) ? r3.z : r1.z;
									r1.z = r1.w * -0.5 + r3.x;
									r3.x = (r4.w >= 0) ? r3.x : r1.z;
									r4.zw = r3.yy * -0.25 + abs(r3.zx);
									r5.xy = (r4.zw >= 0) ? 0 : 1;
									r1.z = r5.y + r5.x;
									if (-r1.z < 0) {
										if (abs(r3.z) >= r2.x) {
										} else {
											r3.z = r5.w;
										}
										if (abs(r3.x) >= r2.x) {
										} else {
											r3.x = r5.w;
										}
										r1.z = r1.w * -0.5 + r3.z;
										r3.z = (r4.z >= 0) ? r3.z : r1.z;
										r1.z = r1.w * -0.5 + r3.x;
										r3.x = (r4.w >= 0) ? r3.x : r1.z;
										r4.zw = r3.yy * -0.25 + abs(r3.zx);
										r5.xy = (r4.zw >= 0) ? 0 : 1;
										r1.z = r5.y + r5.x;
										if (-r1.z < 0) {
											if (abs(r3.z) >= r2.x) {
											} else {
												r3.z = r5.w;
											}
											if (abs(r3.x) >= r2.x) {
											} else {
												r3.x = r5.w;
											}
											r1.z = r1.w * -0.5 + r3.z;
											r3.z = (r4.z >= 0) ? r3.z : r1.z;
											r1.z = r1.w * -0.5 + r3.x;
											r3.x = (r4.w >= 0) ? r3.x : r1.z;
											r4.zw = r3.yy * -0.25 + abs(r3.zx);
											r5.xy = (r4.zw >= 0) ? 0 : 1;
											r1.z = r5.y + r5.x;
											if (-r1.z < 0) {
												if (abs(r3.z) >= r2.x) {
												} else {
													r3.z = r5.w;
												}
												if (abs(r3.x) >= r2.x) {
												} else {
													r3.x = r5.w;
												}
												r1.z = r1.w * -0.5 + r3.z;
												r3.z = (r4.z >= 0) ? r3.z : r1.z;
												r1.z = r1.w * -0.5 + r3.x;
												r3.x = (r4.w >= 0) ? r3.x : r1.z;
												r3.yw = r3.yy * -0.25 + abs(r3.zx);
												r4.zw = (r3.yw >= 0) ? 0 : 1;
												r1.z = r4.w + r4.z;
												if (-r1.z < 0) {
													if (abs(r3.z) >= r2.x) {
													} else {
														r3.z = r5.w;
													}
													if (abs(r3.x) >= r2.x) {
													} else {
														r3.x = r5.w;
													}
													r1.z = r1.w * -0.5 + r3.z;
													r3.z = (r3.y >= 0) ? r3.z : r1.z;
													r1.z = r1.w * -0.5 + r3.x;
													r3.x = (r3.w >= 0) ? r3.x : r1.z;
													r1.zw = r4.xy;
												} else {
													r1.zw = r4.xy;
												}
											} else {
												r1.zw = r4.xy;
											}
										} else {
											r1.zw = r4.xy;
										}
									} else {
										r1.zw = r4.xy;
									}
								} else {
									r1.zw = r4.xy;
								}
							} else {
								r1.zw = r4.xy;
							}
						} else {
							r1.zw = r4.xy;
						}
					} else {
						r1.zw = r4.xy;
					}
				} else {
					r1.zw = r4.xy;
				}
			} else {
				r1.zw = r4.xy;
			}
		} else {
			r1.zw = r4.xy;
		}
		r2.x = r4.x + -texcoord.x;
		r1.zw = -r1.zw + texcoord.xy;
		r1.z = (r1.x >= 0) ? r1.z : r1.w;
		r1.w = r4.y + -texcoord.y;
		r1.w = (r1.x >= 0) ? r2.x : r1.w;
		r2.xw = (r3.zx >= 0) ? 0 : 1;
		r2.z = (r2.z >= 0) ? -0 : -1;
		r2.xz = r2.zz + r2.xw;
		r2.w = r1.z + r1.w;
		r2.w = 1 / r2.w;
		r3.x = -r1.w + r1.z;
		r3.y = min(r1.w, r1.z);
		r1.z = (r3.x >= 0) ? abs(r2.z) : abs(r2.x);
		r1.y = r1.y * r1.y;
		r1.w = r3.y * -r2.w + 0.5;
		r1.y = r1.y * 0.75;
		r1.z = (-r1.z >= 0) ? 0 : r1.w;
		r2.x = max(r1.z, r1.y);
		r1.yz = r2.xx * r2.yy + texcoord.xy;
		r2.x = (r1.x >= 0) ? texcoord.x : r1.y;
		r2.y = (r1.x >= 0) ? r1.z : texcoord.y;
		r2.zw = 0;
		r1 = tex2Dlod(BackBufferSampler, r2);
		o.xyz = saturate(r1.xyz);
	}
	o.w = saturate(r0.w);

	return o;
}
