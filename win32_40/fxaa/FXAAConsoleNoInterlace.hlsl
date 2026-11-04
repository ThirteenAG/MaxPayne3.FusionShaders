cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
};

SamplerState BackBufferSampler : register(s0);
Texture2D BackBuffer : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0.xy = asint(globalScreenSize.zw * float2(0.5, 0.5));
	r1.xy = asint(-(globalScreenSize.zw) * float2(0.5, 0.5) + i.texcoord.xy);
	r1.zw = asint(globalScreenSize.zw * float2(0.5, 0.5) + i.texcoord.xy);
	r2 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.xy), 0);
	r3 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.xw), 0);
	r4 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.zy), 0);
	r1 = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.zw), 0));
	r5 = BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0);
	r0.z = asint(max(r2.w, r3.w));
	r0.w = asint(r4.w + 0.00260416674);
	r1.x = asint(min(r2.w, r3.w));
	r1.y = asint(max(asfloat(r1.w), asfloat(r0.w)));
	r1.z = asint(min(asfloat(r1.w), asfloat(r0.w)));
	r0.z = asint(max(asfloat(r0.z), asfloat(r1.y)));
	r1.x = asint(min(asfloat(r1.x), asfloat(r1.z)));
	r1.y = asint(asfloat(r0.z) * 0.125);
	r1.z = asint(min(r5.w, asfloat(r1.x)));
	r1.y = asint(max(asfloat(r1.y), 0.0500000007));
	r2.x = max(r5.w, asfloat(r0.z));
	r1.z = asint(-(asfloat(r1.z)) + r2.x);
	r1.y = (asfloat(r1.z) >= asfloat(r1.y)) ? -1 : 0;
	if (r1.y != 0) {
		r1.yz = asint(globalScreenSize.zw + globalScreenSize.zw);
		r0.w = asint(-(asfloat(r0.w)) + r3.w);
		r1.w = asint(-(r2.w) + asfloat(r1.w));
		r2.x = asfloat(r0.w) + asfloat(r1.w);
		r2.y = asfloat(r0.w) + -(asfloat(r1.w));
		r0.w = asint(dot(r2.xy, r2.xy));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r2.xy = asfloat(r0.ww) * r2.xy;
		r2.zw = -(r2.xy) * asfloat(r0.xy) + i.texcoord.xy;
		r3 = BackBuffer.SampleLevel(BackBufferSampler, r2.zw, 0);
		r0.xy = asint(r2.xy * asfloat(r0.xy) + i.texcoord.xy);
		r4 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r0.xy), 0);
		r0.x = asint(min(abs(r2.y), abs(r2.x)));
		r0.x = asint(asfloat(r0.x) * 8);
		r0.xy = asint(r2.xy / asfloat(r0.xx));
		r0.xy = asint(max(asfloat(r0.xy), float2(-2, -2)));
		r0.xy = asint(min(asfloat(r0.xy), float2(2, 2)));
		r2.xy = -(asfloat(r0.xy)) * asfloat(r1.yz) + i.texcoord.xy;
		r2 = BackBuffer.SampleLevel(BackBufferSampler, r2.xy, 0);
		r0.xy = asint(asfloat(r0.xy) * asfloat(r1.yz) + i.texcoord.xy);
		r6 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r0.xy), 0);
		r3 = r3 + r4;
		r2 = r2 + r6;
		r4 = r3 * float4(0.25, 0.25, 0.25, 0.25);
		r2 = r2 * float4(0.25, 0.25, 0.25, 0.25) + r4;
		r0.x = (r2.w < asfloat(r1.x)) ? -1 : 0;
		r0.y = (asfloat(r0.z) < r2.w) ? -1 : 0;
		r0.x = r0.y | r0.x;
		r0.yzw = asint(r3.xyz * float3(0.5, 0.5, 0.5));
		o.xyz = (r0.xxx != 0) ? asfloat(r0.yzw) : r2.xyz;
		o.w = r2.w;
	} else {
		o = r5;
	}

	return o;
}
