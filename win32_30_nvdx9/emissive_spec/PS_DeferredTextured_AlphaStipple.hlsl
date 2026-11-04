sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c201);
float specularFactor : register(c200);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float2 vpos : VPOS;
	float4 color : COLOR;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0 = r0 * colorize;
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r1.yz = 0.5 * i.vpos.xy;
	r1.yz = frac(abs(r1.yz));
	r1.yz = (i.vpos.xy >= 0) ? r1.yz : -r1.yz;
	r1.yz = r1.yz + r1.yz;
	r2.xy = frac(r1.yz);
	r1.yz = r1.yz + -r2.xy;
	r1.y = r1.z * 2 + r1.y;
	r2 = r1.y + float4(-0, -1, -2, -3);
	r2 = (-abs(r2) >= 0) ? 1 : 0;
	r1.y = dot(stipplePattern, r2);
	r0.w = r0.w * -globalScalars.x + r1.y;
	r2 = (r0.w >= 0) ? -1 : -0;
	clip(r2);
	r1.yzw = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.yzw);
	r1.zw = float2(1, 0);
	r0.w = r1.z + -specularFactor.x;
	r1.y = saturate(-r1.z + globalScalars.z);
	o.color.xyz = r1.yyy * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.y = 0.0051020407;
	r0.x = saturate(r0.y * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r0.w >= 0) ? 0.26726124 : r0.x;
	r0.z = globalScalars.z;
	o.color2.z = r0.z * gAmbientOcclusionEffect.w;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.x = specularColorFactor.x;
	o.color2.w = r1.x;
	o.color3 = r1.wwwz * gStencil.x;

	return o;
}
