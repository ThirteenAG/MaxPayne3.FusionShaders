SamplerState imposterSampler : register(s1);
SamplerState blitSampler : register(s2);
Texture2D imposterSampler_tex : register(t1);
Texture2D blitSampler_tex : register(t2);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
	float4 sv_target2 : SV_Target2;
	float4 sv_target3 : SV_Target3;
	uint sv_coverage : SV_Coverage;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	int2 r4;
	r0 = asint(ddx_coarse(i.texcoord.xyxy));
	r1 = asint(ddy_coarse(i.texcoord.xyxy));
	r1 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r1));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(imposterSampler_tex.Sample(imposterSampler, asfloat(r0.xy)).xwyz);
	r0.x = asint(asfloat(r1.y) + -0.5);
	r0.x = (asfloat(r0.x) >= 0) ? -1 : 0;
	r2.xyz = asint(asfloat(r1.yyy) * asfloat(r1.xzw));
	r2.xyz = r0.xxx & r2.xyz;
	r1.x = 1;
	r1.xy = r0.xx & r1.xy;
	r3 = imposterSampler_tex.Sample(imposterSampler, asfloat(r0.zw));
	r0.y = asint(r3.w + -0.5);
	r0.y = (asfloat(r0.y) >= 0) ? -1 : 0;
	r4.x = (2 & ~1) | (r0.x & 1);
	r0.xzw = asint(r3.xyz * r3.www + asfloat(r2.xyz));
	r4.y = asint(asfloat(r1.y) + r3.w);
	r0.xzw = (r0.yyy != 0) ? r0.xzw : r2.xyz;
	r1.xy = (r0.yy != 0) ? r4.xy : r1.xy;
	r0.xyz = asint(asfloat(r0.xzw) / asfloat(r1.yyy));
	r0.w = r1.y;
	r2 = asint(asfloat(r0) * float4(15.9377499, 15.9377499, 15.9377499, 15.9377499));
	r2 = asint(frac(asfloat(r2)));
	r2 = asint(asfloat(r2) * float4(16, 16, 16, 16));
	r0 = asint(asfloat(r0) * float4(255.003998, 255.003998, 255.003998, 255.003998) + -(asfloat(r2)));
	r0 = asint(asfloat(r0) * float4(0.0625, 0.0625, 0.0625, 0.0625));
	r1.y = asint(dot(asfloat(r2), i.texcoord1));
	r1.z = asint(dot(asfloat(r0), i.texcoord2));
	r1.y = asint(asfloat(r1.z) + asfloat(r1.y));
	r1.z = asint(dot(asfloat(r2), i.texcoord3));
	r0.x = asint(dot(asfloat(r0), i.texcoord4));
	r0.x = asint(asfloat(r0.x) + asfloat(r1.z));
	r0.y = asint(saturate(asfloat(r1.y)));
	r0.z = asint(saturate(asfloat(r0.x)));
	r0.z = asint(asfloat(r0.z) * i.texcoord.w);
	r0.y = asint(asfloat(r0.y) * i.texcoord.z + asfloat(r0.z));
	r0.y = asint(asfloat(r0.y) * i.color.w);
	r0.z = (asfloat(r0.y) < 0.5) ? -1 : 0;
	if (r0.z != 0) discard;
	r2.xyz = asint(imposterSampler_tex.Sample(imposterSampler, float2(0.9921875, 0.0078125)).xyz);
	r0.z = asint(floor(asfloat(r1.y)));
	r3.x = asfloat(r0.z) * 0.0625;
	r3.yw = float2(0.5, 0.5);
	r1.yzw = asint(blitSampler_tex.Sample(blitSampler, r3.xy).xyz);
	r1.yzw = asint(asfloat(r1.yzw) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.x = asint(floor(asfloat(r0.x)));
	r3.z = asfloat(r0.x) * 0.0625;
	r0.xzw = asint(blitSampler_tex.Sample(blitSampler, r3.zw).xyz);
	r0.xzw = asint(asfloat(r0.xzw) * float3(2, 2, 2) + float3(-1, -1, -1));
	r0.xzw = asint(asfloat(r0.xzw) * i.texcoord.www);
	r0.xzw = asint(asfloat(r1.yzw) * i.texcoord.zzz + asfloat(r0.xzw));
	r0.xzw = asint(asfloat(r0.xzw) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.y = asint(dot(asfloat(r0.xzw), asfloat(r0.xzw)));
	r1.y = asint(rsqrt(asfloat(r1.y)));
	r0.xzw = asint(asfloat(r0.xzw) * asfloat(r1.yyy));
	r1.yzw = asint(asfloat(r0.zzz) * i.texcoord6.xyz);
	r1.yzw = asint(i.texcoord5.xyz * asfloat(r0.xxx) + asfloat(r1.yzw));
	r0.xzw = asint(i.texcoord7.xyz * asfloat(r0.www) + asfloat(r1.yzw));
	o.sv_target1.xyz = asfloat(r0.xzw) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.xz = asint(frac(i.sv_position.xy));
	r0.xz = asint(asfloat(r0.xz) + float2(-0.5, -0.5));
	o.sv_target2.w = dot(abs(asfloat(r0.xz)), float2(1000, 1000));
	o.sv_target.xyz = asfloat(r2.xyz);
	o.sv_target.w = asfloat(r0.y);
	o.sv_target1.w = 0;
	o.sv_target2.xyz = float3(0, 0.5, 0.5);
	o.sv_target3.xyz = float3(0, 0, 0);
	o.sv_target3.w = asfloat(r0.y);
	o.sv_coverage = r1.x;

	return o;
}
