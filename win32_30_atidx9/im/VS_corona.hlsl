sampler2D CoronasDepthMapSampler : register(s0);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScreenSize : register(c41);
float2 poisson12[12] : register(c210);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.xyz = i.normal.xyz;
	r0.xyz = -r0.xyz + i.position.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r0.w = r0.w * 0.70710677;
	r1.xyz = -gViewInverse[3].xyz + i.normal.xyz;
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	r1.w = 1 / r1.w;
	if (r1.w < r0.w) {
		r2.x = gWorldView[0].z;
		r2.y = gWorldView[1].z;
		r2.z = gWorldView[2].z;
		r1.x = dot(r2.xyz, r1.xyz);
		r1.y = (-r1.x < r0.w) ? 1 : 0;
		r0.w = 1 / r0.w;
		r0.w = -r1.x * r0.w + 1;
		r3.w = saturate(r0.w * 0.5);
		r0.w = (-r1.x < 0.1) ? 1 : 0;
		r1.x = r1.x + 0.1;
		r1.xzw = r1.xxx * r2.xyz;
		r3.xyz = r0.www * -r1.xzw + i.position.xyz;
		r2 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
		r4 = lerp(r2, r3, r1.y);
	} else {
		r1 = gWorldViewProj[1] * i.normal.y;
		r1 = i.normal.x * gWorldViewProj[0] + r1;
		r1 = i.normal.z * gWorldViewProj[2] + r1;
		r1 = r1 + gWorldViewProj[3];
		r2.xyz = gWorldViewProj[1].xyw * i.position.yyy;
		r2.xyz = i.position.xxx * gWorldViewProj[0].xyw + r2.xyz;
		r2.xyz = i.position.zzz * gWorldViewProj[2].xyw + r2.xyz;
		r2.xyz = r2.xyz + gWorldViewProj[3].xyw;
		r0.w = 1 / r1.w;
		r1.xyz = r0.www * r1.xyz;
		r0.w = 1 / r2.z;
		r2.xy = r2.xy * r0.ww + -r1.xy;
		r2.xy = r2.xy * globalScreenSize.xy;
		r2.xy = r2.xy * r2.xy;
		r0.w = r2.y + r2.x;
		r0.w = rsqrt(r0.w);
		r0.w = 1 / r0.w;
		r0.w = r0.w * 0.35355338;
		r0.w = min(r0.w, 32);
		r2.zw = 0;
		r4.w = 0;
		for (int i0 = 0; i0 < 12; i0++) {
			r3.zw = globalScreenSize.zw;
			r3.xy = r3.zw * poisson12[i0].xy;
			r3.xy = r3.xy * r0.ww + r1.xy;
			r3.xy = max(r3.xy, -0.997);
			r3.xy = min(r3.xy, 0.997);
			r2.xy = r3.xy * float2(0.5, -0.5) + 0.5;
			r3 = tex2Dlod(CoronasDepthMapSampler, r2);
			r1.w = (r1.z < r3.x) ? 1 : 0;
			r4.w = r1.w * 0.083333336 + r4.w;
		}
		r0.w = (0.01 < r4.w) ? 1 : 0;
		r4.xyz = r0.www * r0.xyz + i.normal.xyz;
	}
	r0 = r4.y * gWorldViewProj[1];
	r0 = r4.x * gWorldViewProj[0] + r0;
	r0 = r4.z * gWorldViewProj[2] + r0;
	o.position = r0 + gWorldViewProj[3];
	r0.xyz = r4.www * i.color.xyz;
	o.texcoord1.xyz = r0.xyz * i.texcoord.yyy;
	o.texcoord.x = i.texcoord.x;
	o.texcoord.y = i.color.w;
	o.texcoord1.w = 1;

	return o;
}
