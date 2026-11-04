sampler2D GBufferTextureSampler1 : register(s12);
sampler2D GBufferTextureSampler2 : register(s13);
sampler2D ReflectTextureSampler : register(s14);
float4 TextureSize : register(c222);
row_major float4x4 gWorldView : register(c4);
float4 globalScreenSize : register(c41);
float mirrorIntensity : register(c221);
float mirrorNormalIntensity : register(c219);
float mirrorSpecMaskIntensity : register(c220);

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.x = 1 / abs(i.texcoord1.w);
	r0.x = r0.x * -0.5;
	r0.y = -1.75 + abs(i.texcoord1.w);
	r0.x = (r0.y >= 0) ? r0.x : -0.2857143;
	r0.xy = i.texcoord1.xy * r0.xx + 0.5;
	r0.zw = 0.51 + i.vpos.xy;
	r0.zw = r0.zw * globalScreenSize.zw;
	r1 = tex2D(GBufferTextureSampler1, r0.zw);
	r2 = tex2D(GBufferTextureSampler2, r0.zw);
	r1.xyz = r1.xyz * 2 + -1;
	r0.z = dot(r1.xyz, r1.xyz);
	r0.z = rsqrt(r0.z);
	r1.xyz = r1.xyz * r0.zzz + -i.texcoord2.xyz;
	r0.zw = r1.yy * gWorldView[1].xy;
	r0.zw = r1.xx * gWorldView[0].xy + r0.zw;
	r0.zw = r1.zz * gWorldView[2].xy + r0.zw;
	r0.yz = r0.zw * -mirrorNormalIntensity.xx + r0.xy;
	r1.x = 1 / TextureSize.y;
	r0.w = r0.z + r1.x;
	r1 = tex2D(ReflectTextureSampler, r0.yw);
	r3 = tex2D(ReflectTextureSampler, r0.yz);
	r1.xyz = r1.xyz + r3.xyz;
	r1.w = 1 / TextureSize.x;
	r0.x = r0.y + r1.w;
	r3 = tex2D(ReflectTextureSampler, r0.xz);
	r0 = tex2D(ReflectTextureSampler, r0.xw);
	r1.xyz = r1.xyz + r3.xyz;
	r0.xyz = r0.xyz + r1.xyz;
	r0.xyz = r0.xyz * 0.25;
	r0.xyz = r0.xyz * r0.xyz;
	r0.xyz = r0.xyz * 16;
	r0.w = saturate(r2.z * 3.3333333 + 0.025);
	r1.x = saturate(mirrorSpecMaskIntensity.x);
	r3.x = lerp(1, r2.x, r1.x);
	r0.xyz = r0.xyz * r3.xxx;
	r0.xyz = r0.xyz * mirrorIntensity.xxx;
	o.xyz = r0.www * r0.xyz;
	o.w = 1;

	return o;
}
