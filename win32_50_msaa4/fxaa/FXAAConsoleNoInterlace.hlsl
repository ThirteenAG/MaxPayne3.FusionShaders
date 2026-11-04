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

	float4 r0;
	int4 r1;
	float4 r2;
	int4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	r0.xy = globalScreenSize.zw * float2(0.5, 0.5);
	r1.xy = asint(-(globalScreenSize.zw) * float2(0.5, 0.5) + i.texcoord.xy);
	r1.zw = asint(globalScreenSize.zw * float2(0.5, 0.5) + i.texcoord.xy);
	r0.z = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.xy), 0).w;
	r0.w = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.xw), 0).w;
	r1.x = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.zy), 0).w);
	r1.y = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.zw), 0).w);
	r2 = BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0);
	r1.z = asint(max(r0.w, r0.z));
	r1.x = asint(asfloat(r1.x) + 0.00260416674);
	r1.w = asint(min(r0.w, r0.z));
	r3.x = asint(max(asfloat(r1.y), asfloat(r1.x)));
	r3.y = asint(min(asfloat(r1.y), asfloat(r1.x)));
	r1.z = asint(max(asfloat(r1.z), asfloat(r3.x)));
	r1.w = asint(min(asfloat(r1.w), asfloat(r3.y)));
	r3.x = asint(asfloat(r1.z) * 0.125);
	r3.y = asint(min(r2.w, asfloat(r1.w)));
	r3.x = asint(max(asfloat(r3.x), 0.0500000007));
	r3.z = asint(max(r2.w, asfloat(r1.z)));
	r3.y = asint(-(asfloat(r3.y)) + asfloat(r3.z));
	r3.x = (asfloat(r3.y) >= asfloat(r3.x)) ? -1 : 0;
	if (r3.x != 0) {
		r3.xy = asint(globalScreenSize.zw + globalScreenSize.zw);
		r0.w = r0.w + -(asfloat(r1.x));
		r0.z = -(r0.z) + asfloat(r1.y);
		r1.x = asint(r0.z + r0.w);
		r1.y = asint(-(r0.z) + r0.w);
		r0.z = dot(asfloat(r1.xy), asfloat(r1.xy));
		r0.z = rsqrt(r0.z);
		r0.zw = r0.zz * asfloat(r1.xy);
		r1.xy = asint(-(r0.zw) * r0.xy + i.texcoord.xy);
		r4 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r1.xy), 0);
		r0.xy = r0.zw * r0.xy + i.texcoord.xy;
		r5 = BackBuffer.SampleLevel(BackBufferSampler, r0.xy, 0);
		r0.x = min(abs(r0.w), abs(r0.z));
		r0.x = r0.x * 8;
		r0.xy = r0.zw / r0.xx;
		r0.xy = max(r0.xy, float2(-2, -2));
		r0.xy = min(r0.xy, float2(2, 2));
		r0.zw = -(r0.xy) * asfloat(r3.xy) + i.texcoord.xy;
		r6 = BackBuffer.SampleLevel(BackBufferSampler, r0.zw, 0);
		r0.xy = r0.xy * asfloat(r3.xy) + i.texcoord.xy;
		r0 = BackBuffer.SampleLevel(BackBufferSampler, r0.xy, 0);
		r3 = asint(r4 + r5);
		r0 = r0 + r6;
		r4 = asfloat(r3) * float4(0.25, 0.25, 0.25, 0.25);
		r0 = r0 * float4(0.25, 0.25, 0.25, 0.25) + r4;
		r1.x = (r0.w < asfloat(r1.w)) ? -1 : 0;
		r1.y = (asfloat(r1.z) < r0.w) ? -1 : 0;
		r1.x = r1.y | r1.x;
		r1.yzw = asint(asfloat(r3.xyz) * float3(0.5, 0.5, 0.5));
		o.xyz = (r1.xxx != 0) ? asfloat(r1.yzw) : r0.xyz;
		o.w = r0.w;
	} else {
		o = r2;
	}

	return o;
}
